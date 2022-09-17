import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tare_app/providers/tare_range.dart';

class TarePage extends StatefulWidget {
  const TarePage({Key? key}) : super(key: key);

  @override
  TarePageState createState() {
    return TarePageState();
  }
}

class TarePageState extends State<TarePage> {
  final _formKey = GlobalKey<FormState>();
  final _tareController = TextEditingController();
  final _rangeController = TextEditingController();
  bool _enabled = false;
  String _enabledText = "Ativar";

  @override
  void initState() {
    super.initState();
    _rangeController.text = '10.0';
  }

  String commaToDot(String n) {
    // Replace from ',' to '.' if any (1114,0 -> 1114.0)
    return n.replaceAll(',', '.');
  }

  bool isNotCorrectFloat(String n) {
    // Check whether the input text is correctly formatted as a float number
    return !RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(n);
  }

  String? validator(String? value) {
    value = commaToDot(value ?? '');
    if (value.isEmpty) {
      return 'Please enter some text';
    } else if (isNotCorrectFloat(value)) {
      return 'Please enter a valid float number.';
    }

    return null;
  }

  Future<String?> updateTareRange() {
    // Invoke the provider and clear the input fields.
    // Return  null on fail.
    final tareRange = Provider.of<TareRangeProvider>(context, listen: false);
    final updateOrNull = tareRange.updateTareRange(
      _tareController.text,
      _rangeController.text,
    );
    _tareController.clear();
    _rangeController.clear();
    return updateOrNull;
  }

  Future<void> isInputValid() async {
    // Check whether the fields have valid inputs or not.
    // Call the update data use case and display a snackbar on success.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final res = await updateTareRange();
      if (res != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tare and Range successfully saved.'),
            backgroundColor: Colors.teal,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error ocurred during file manipulation.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both fields must be correctly filled.'),
          backgroundColor: Colors.deepOrange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    // AppBar's height == 56px, padding top + bottom == 24px
    final height = screenSize.height - 56 - 2 * 12;

    return FutureBuilder<Map<String, double>?>(
      future: Provider.of<TareRangeProvider>(context).readTareRange(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              height: height,
              width: width / 2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.shade300,
                  width: 4.0,
                ),
              ),
              child: Text(
                "An error occurred during file reading",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline1!.fontSize,
                  color: Colors.red,
                ),
              ),
            ),
          );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  height: height,
                  width: width / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 4.0,
                    ),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final tare = snapshot.data!['tare'] as double;
              final range = snapshot.data!['range'] as double;
              final minWeight = double.parse((tare - range).toStringAsFixed(2));
              final maxWeight = double.parse((tare + range).toStringAsFixed(2));

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: height,
                    width: width / 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Valores atualizados (em gramas):",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Tara",
                                              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 30),
                                            ),
                                            Center(
                                              child: Text(
                                                "$tare",
                                                style: Theme.of(context).textTheme.headline2!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.teal,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Intervalo",
                                              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 30),
                                            ),
                                            Center(
                                              child: Text(
                                                "$range",
                                                style: Theme.of(context).textTheme.headline2!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.teal,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Peso mínimo: ${minWeight}g",
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                    Text(
                                      "Peso máximo: ${maxWeight}g",
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Alterar valores:",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Container(
                                height: height / 5,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 6.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.subtitle1,
                                        children: const [
                                          TextSpan(
                                            text: "1. Tara",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ": digite o valor (g) desejado no campo adequado abaixo.",
                                          )
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.subtitle1,
                                        children: const [
                                          TextSpan(
                                            text: "2. Intervalo",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                                ": não é obrigatório digitar um valor (por padrão é 10.0 gramas). Porém, caso seja necessário, ative o campo pressionando o botão 'Ativar' e digite o valor desejado em gramas.",
                                          )
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.subtitle1,
                                        children: const [
                                          TextSpan(
                                            text: "3. Alterar",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ": pressione a tecla Enter ou o botão Salvar.",
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _tareController,
                                      autofocus: true,
                                      validator: validator,
                                      onFieldSubmitted: (_) {
                                        setState(() {
                                          isInputValid();
                                        });
                                      },
                                      onSaved: (value) {
                                        _tareController.text = commaToDot(value!);
                                      },
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                      ),
                                      decoration: const InputDecoration(
                                        label: Text("Tara"),
                                        labelStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        hintText: "Ex.: 1114.0, 980.5, 1250.40, 777.777",
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2.0,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            enabled: _enabled,
                                            controller: _rangeController,
                                            validator: validator,
                                            onFieldSubmitted: (_) {
                                              setState(() {
                                                isInputValid();
                                              });
                                            },
                                            onSaved: (value) {
                                              _rangeController.text = commaToDot(value!);
                                            },
                                            style:
                                                TextStyle(fontSize: 20.0, color: _enabled ? Colors.black : Colors.grey),
                                            decoration: InputDecoration(
                                              label: const Text("Intervalo"),
                                              labelStyle: TextStyle(
                                                fontSize: 20.0,
                                                color: _enabled ? Colors.black : Colors.grey,
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: _enabled ? Colors.teal : null,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              border: const OutlineInputBorder(),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              filled: !_enabled,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _enabled = !_enabled;
                                              _enabledText = _enabled ? "Desativar" : "Ativar";
                                            });
                                          },
                                          child: Text(
                                            _enabledText,
                                            style: const TextStyle(fontSize: 16.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isInputValid();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 64.0,
                                            vertical: 16.0,
                                          ),
                                          textStyle: const TextStyle(fontSize: 20.0),
                                        ),
                                        child: const Text(
                                          'Salvar',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        }
      },
    );
  }
}
