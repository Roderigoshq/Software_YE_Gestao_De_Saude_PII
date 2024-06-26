import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:uuid/uuid.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationModal extends StatefulWidget {
  final MedicationModel? medication;

  const MedicationModal({super.key, this.medication});

  @override
  State<MedicationModal> createState() => _MedicationModalState();
}

class _MedicationModalState extends State<MedicationModal> {
  final MedicationService _medicationService = MedicationService();
  final TextEditingController _dosagemCtrl = TextEditingController();
  late final ValueNotifier<List<DateTime>> _selectedDays;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedUnit = 'mg';  // Unit of dosage.
  bool _reminder = false;  // For enabling/disabling a reminder.
  bool isCarregando = false;
  String? _selectedMedication;  // Variable to hold the selected medication

  final OutlineInputBorder _borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(
      color: Color.fromRGBO(136, 149, 83, 1),
    ),
  );

  @override
  void initState() {
    super.initState();
    _selectedDays = ValueNotifier([]);

    if (widget.medication != null) {
      _selectedMedication = widget.medication!.name;
      _dosagemCtrl.text = widget.medication!.dosage.split(' ')[0];
      _selectedUnit = widget.medication!.dosage.split(' ')[1];
      _selectedDays.value = widget.medication!.dates.map((date) => DateFormat('yyyy-MM-dd').parse(date)).toList();
      _selectedTime = TimeOfDay(hour: widget.medication!.hour, minute: widget.medication!.minute);
      _reminder = widget.medication!.reminder;
    }
  }

  @override
  void dispose() {
    _selectedDays.dispose();
    _dosagemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const Divider(),
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildMedicationInput(),
            const SizedBox(height: 20),
            _buildDosageInput(),
            const SizedBox(height: 20),
            _buildTimePicker(),
            const SizedBox(height: 20),
            _buildReminderSwitch(),
            if (isCarregando) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: Color.fromRGBO(136, 149, 83, 1), fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Text("Medicamentos", style: TextStyle(color: Colors.grey, fontSize: 18)),
        GestureDetector(
          onTap: _adicionarMedicacao,
          child: const Text("Salvar", style: TextStyle(color: Color.fromRGBO(136, 149, 83, 1), fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
  return ValueListenableBuilder<List<DateTime>>(
    valueListenable: _selectedDays,
    builder: (context, value, _) {
      return TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => value.any((selectedDay) => isSameDay(selectedDay, day)),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            if (value.any((day) => isSameDay(day, selectedDay))) {
              _selectedDays.value = List.from(value)..removeWhere((day) => isSameDay(day, selectedDay));
            } else {
              _selectedDays.value = List.from(value)..add(selectedDay);
            }
          });
        },
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Color.fromRGBO(136, 149, 83, 1),
            shape: BoxShape.circle,
          ),
          ),
        );
    },
      );
    }




  Widget _buildMedicationInput() {
    List<String> medicamentos = [
      "Addera D3", "Advil", "Aerolin", "Allegra", "Amoxicilina", "Anador", "Anthelios", 
      "Aspirina", "Atorvastatina", "Azitromicina", "Bactrim", "Benegrip", "Berotec", 
      "Bisolvon", "Buscopan", "Captopril", "Cefalexina", "Cetoconazol", "Ciprofloxacino", 
      "Claritin", "Clavulin", "Clexane", "Clonazepam", "Clopidogrel", "Cymbalta", 
      "Daflon", "Decadron", "Desalex", "Dexason", "Diazepam", "Dipirona", "Dorflex", 
      "Dramin", "Duo Travatan", "Engov", "Esomeprazol", "Feldene", "Fluconazol", 
      "Fluoxetina", "Frontal", "Furosemida", "Gliclazida", "Glifage", "Hidroclorotiazida", 
      "Ibuprofeno", "Inalapril", "Kalyamon", "Lansoprazol", "Loratadina", "Losartana", 
      "Lyrica", "Magnésia Bisurada", "Maleato de Dexclorfeniramina", "Mioflex", "Neosoro", 
      "Nimesulida", "Novalgina", "Omeprazol", "Pantoprazol", "Paracetamol", "Pax", 
      "Penicilina", "Plavix", "Prednisona", "Profenid", "Puran T4", "Pyridium", 
      "Ranitidina", "Rivotril", "Rosuvastatina", "Saúde Animal", "Selozok", "Sildenafil", 
      "Sinvastatina", "Sivastin", "Spidufen", "Spironolactona", "Succinato de Metoprolol", 
      "Sustrate", "Tadalafila", "Tamsulosina", "Tenoxican", "Torsilax", "Tramal", 
      "Tylex", "Valsartana", "Venlafaxina", "Venvanse", "Viagra", "Victan", "Vitamina C", 
      "Vitamina D", "Vodol", "Xarelto", "Xylocaína", "Zolpidem", "Zyrtec"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medicamento:', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedMedication,
          hint: const Text('Selecione o medicamento'),
          onChanged: (String? newValue) {
            setState(() {
              _selectedMedication = newValue!;
            });
          },
          items: medicamentos.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            border: _borderStyle,
            focusedBorder: _borderStyle,
          ),
        ),
      ],
    );
  }

  
Widget _buildDosageInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Dosagem:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _dosagemCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                hintText: 'Digite a dosagem',
                border: _borderStyle,
                focusedBorder: _borderStyle,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: _selectedUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                });
              },
              items: <String>['mg', 'ml', 'g', 'mcg', 'gotas'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: Container(), // Remove a linha inferior padrão do DropdownButton
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horário:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderSwitch() {
    return SwitchListTile(
      title: const Text(
        'Ativar lembrete',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      value: _reminder,
      onChanged: (bool value) {
        setState(() {
          _reminder = value;
        });
      },
      activeColor: const Color.fromRGBO(136, 149, 83, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  void _pickTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  void _adicionarMedicacao() async {
    if (_selectedMedication == null || _dosagemCtrl.text.isEmpty || _selectedDays.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos')));
      return;
    }

    setState(() => isCarregando = true);

    List<String> formattedDates = _selectedDays.value.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList();

    final MedicationModel newMedication = MedicationModel(
      id: widget.medication?.id ?? Uuid().v4(),
      name: _selectedMedication!,
      dosage: '${_dosagemCtrl.text} $_selectedUnit',
      dates: formattedDates,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      reminder: _reminder,
    );

    if (widget.medication == null) {
      await _medicationService.addMedication(newMedication);
    } else {
      await _medicationService.editMedication(newMedication.id, newMedication.name, newMedication.dosage, newMedication.dates.join(','), newMedication.hour.toString(), newMedication.minute.toString(), newMedication.reminder);
    }

    Navigator.pop(context, true); // Adicione um parâmetro para indicar sucesso
    setState(() => isCarregando = false);
  }
}
