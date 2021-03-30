import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Variáveis
  final _tConta = TextEditingController();
  final _tContaBebidas = TextEditingController();
  final _tPessoas = TextEditingController();
  final _tGorjeta = TextEditingController();
  final _tPBebem = TextEditingController();
  var _totalText = "";
  var _gorjetaText = "";
  var _individualText = "";
  var _PBebemText = "";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  //Método para limpar os campos
  void _resetFields(){
    _tConta.text = "";
    _tPessoas.text = "";
    _tGorjeta.text = "";
    _tContaBebidas.text = "";
    _tPBebem.text = "";
    setState(() {
      _totalText = "";
      _gorjetaText = "";
      _individualText = "";
      _PBebemText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Valor da Conta - Total (R\$)", _tConta),
              _editText("Valor da Conta - Bebidas (R\$)", _tContaBebidas),
              _editText("Total de Pessoas", _tPessoas),
              _editText("Total de Pessoas que Bebem", _tPBebem),
              _editText("Gorjeta (%)", _tGorjeta),
              _buttonCalcular(),
              _textInfo("Total a pagar:", _totalText),
              _textInfo("Valor da gorjeta:", _gorjetaText),
              _textInfo("Individual para quem bebe:", _individualText),
              _textInfo("Individual para quem não bebe:", _PBebemText),
            ],
          ),
        ),
    );
  }

// Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        ),
        child: Text(
          "Calcular",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            _calculate();
          }
        },
      ),
    );
  }

  void _calculate(){
    setState(() {
      String strConta = _tConta.text.replaceAll(',', '.');
      String strContaBebidas = _tContaBebidas.text.replaceAll(',', '.');
      String strGorjeta = _tGorjeta.text.replaceAll(',', '.');

      double Conta = double.parse(strConta);
      double Gorjeta = (double.parse(strGorjeta) * Conta) / 100;
      double ContaBebidas = double.parse(strContaBebidas);
      double totalConta = Conta+Gorjeta;

      double contaSemBebida =  totalConta - ContaBebidas;

      double Individual = contaSemBebida / int.parse(_tPessoas.text);

      double IndividualBebe = ContaBebidas / int.parse(_tPBebem.text);

      IndividualBebe += Individual;

      _gorjetaText    = "Gorjeta: R\$ " +    Gorjeta.toStringAsFixed(2);
      _gorjetaText    = _gorjetaText.replaceAll('.', ',');

      _individualText = "Valor para quem não bebe: R\$ " + Individual.toStringAsFixed(2);
      _individualText    = _individualText.replaceAll('.', ',');

      _PBebemText = "Valor para quem bebe: R\$ " + IndividualBebe.toStringAsFixed(2);
      _PBebemText    = _PBebemText.replaceAll('.', ',');

      _totalText      = "Total da Conta: R\$ " + totalConta.toStringAsFixed(2);
      _totalText    = _totalText.replaceAll('.', ',');

    });
  }

  _textInfo(String field, var texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
    );
  }

}
