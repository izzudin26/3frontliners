import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscan/qrscan.dart' as Scanner;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Map<String, String>> jsonBooking = [{"iccid": "ICCID", "msisdn": "MSISDN"}];

  String toNumber = "889";
  static String message = "BOOKINGIC.ICCID.MSISDN";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("MediaCell 3Frontliners"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(size.width * .15),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: jsonBooking.asMap().map((i, value) => MapEntry(i,
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                          controller: TextEditingController(text: jsonBooking[i]['iccid']),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: ("ICCID"),
                                suffixIcon: IconButton(
                                  onPressed: () => _scan("iccid", i),
                                  icon: Icon(Icons.qr_code_rounded),
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: TextEditingController(text: jsonBooking[i]['msisdn']),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: ("MSISDN"),
                                suffixIcon: IconButton(
                                  onPressed: () => _scan("msisdn", i),
                                  icon: Icon(Icons.qr_code_rounded),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                )).values.toList(),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          color: Colors.blueAccent,
                          icon: Icon(Icons.add),
                          onPressed: createNew,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          color: Colors.redAccent,
                          icon: Icon(Icons.remove),
                          onPressed: removeBooking,
                        ),
                      ),
                    )
                  ],
                )),
              Container(
                // MessageContainer
                margin: EdgeInsets.only(top: size.width * .2),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: toNumber),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: TextEditingController(text:message),
                        maxLines: 10,
                        minLines: 2,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.message),
                            suffixIcon: IconButton(
                              onPressed: send,
                              icon: Icon(Icons.send),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                      )
                    ),
                  ],
                )
                )
            ],
          ),
        ),
      ),
    );
  }

  void createNew() {
    if(jsonBooking.length < 4) {
      setState(() {
        jsonBooking.add({"iccid": "ICCID", "msisdn": "MSISDN"});
        changeMessageBox();
      });
    }
  }

  void removeBooking(){
    if(jsonBooking.length > 0) {
      setState(() {
        jsonBooking.removeAt(jsonBooking.length - 1);
        changeMessageBox();
      });
    }
  }

  void send() async {
    String uri = "sms:$toNumber?body=$message";
    await launch(uri);
  }

  void clear(String type){
//    setState(() {
//      type == "iccid" ? jso = "" : msisdnText = "";;
//      message = "BOOKINGIC.$iccidText.$msisdnText";
//    });
  }

  Future<void> _scan(String type, int index) async {
    String code = await Scanner.scan();
    setState(() {
      type == "iccid" ? jsonBooking[index]['iccid'] = code : jsonBooking[index]['msisdn'] = code;
      changeMessageBox();
    });
  }

  void changeMessageBox(){
    setState(() {
      List<String> finalMessage = jsonBooking.map((Map<String, String> e) => ".${e['iccid']}.${e['msisdn']}").toList();
      message = "BOOKINGIC${finalMessage.join("")}";
    });
  }

}
