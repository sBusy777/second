import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
 // final _streetAddressController = TextEditingController();
 // final _cityController = TextEditingController();
  final _dateInput = TextEditingController();
  final _timeinput = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  //  _streetAddressController.dispose();
  //  _cityController.dispose();
    _dateInput.dispose();
    _timeinput.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[100],
        title: Text("Forms",
        style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: inputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "name here",
                    labelText: 'Name:'
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "pl fill name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "email here",
                    labelText: 'Mail:'
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "pl fill email";
                  }
                  if(!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value))){
                    return "pl fill proper email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _phoneController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                decoration: inputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "phone here",
                    labelText: 'phone:'
                ),
                validator: (value){
                  if(value==null || value.isEmpty || value.length != 10){
                    return "pl fill proper phone";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: _dateInput,
                readOnly: true,
                onTap: ()async{
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100)
                  );
                  if(pickedDate!=null){
                    String formattedDate = DateFormat('EEE, yyyy-mm-dd').format(pickedDate);
                    _dateInput.text=formattedDate;

                    setState(() {
                      _dateInput.text=formattedDate;
                    });
                  } else {}
                },
             //   keyboardType: TextInputType.name,
                decoration: inputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    hintText: "yyyy-mm-dd",
                    labelText: 'Date:'
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "pl fill name";
                  }
                  return null;
                },
              ),
            SizedBox(height: 10,),
            TextField(
                controller: _timeinput,
                //editing controller of this TextField
                decoration: inputDecoration(
                    prefixIcon: Icon(Icons.watch_later_outlined),
                    hintText: 'hh:mm',
                    labelText: 'Date'),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context, //context of current state
                  );
    if(pickedTime != null ){
    print(pickedTime.format(context)); //output 10:51 PM
    DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
    //converting to DateTime so that we can further format on different pattern.
    print(parsedTime); //output 1970-01-01 22:53:00.000
    String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
    print(formattedTime);
    setState(() {
      _timeinput.text = formattedTime; //set the value of text field.
    });//output 14:59:00
      //DateFormat() is from intl package, you can format the time on any pattern you need.
    }
    else {}
                },
            ),
              SizedBox(height: 10,),
              DropdownButton(
                // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  }
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Hello ${_nameController.text}\nYour details have been submitted and an email sent to ${_emailController.text}.')));
                    } else {
                      // The form has some validation errors.
                      // Do Something...
                    }
                  },
                  child: Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    InputBorder? enabledBorder,
    InputBorder? border,
    Color? fillColor,
    bool? filled,
    Widget? prefixIcon,
    String? hintText,
    String? labelText,
  }) =>
      InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pinkAccent, width: 3.0)
          ),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
          border: border ?? OutlineInputBorder(borderSide: BorderSide()),
          fillColor: fillColor ?? Colors.white,
          filled: filled ?? true,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText);

}