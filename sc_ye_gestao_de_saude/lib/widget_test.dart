import 'package:flutter/material.dart';

class Novals extends StatefulWidget {
  @override
  _NovalsState createState()
  {
    return _NovalsState();
  }
}

class _NovalsState extends State<Novals> {
  var _test = "Full Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
            return StoryWidget(story: {},);
          }
      ),
    );
  }
}

class StoryWidget extends StatefulWidget {
  final Map<String, dynamic> story;
  const StoryWidget({Key? key, required this.story}) : super(key: key);

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {  
bool _expanded = false;

@override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              color: Colors.green,
              child: ExpansionPanelList(
                animationDuration: Duration(milliseconds: 2000),
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(widget.story["name"], style: TextStyle(color: Colors.black),),
                      );
                    },
                    body:ListTile(
                      title: Text(widget.story["lines"],style: TextStyle(color: Colors.black)),
                    ),
                    isExpanded: _expanded,
                    canTapOnHeader: true,
                  ),
                ],
                dividerColor: Colors.grey,
                expansionCallback: (panelIndex, isExpanded) {
                  _expanded = !_expanded;
                  setState(() {});
                },
              ),
            ),
          ),
        ]
    );
  }
}