import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:app_sharedpreferences/Model/item.model.dart';
import 'package:app_sharedpreferences/Controller/item.controller.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  var _controller = ItemController();

  String _theme = 'Light';
  var _themeData = ThemeData.light();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getAll().then((data) {
        setState(() {
          _listagem = _controller.list;
        });
      });
    });
  }
  //Forms
  final _formKey = GlobalKey<FormState>();
  var _nameitemController = TextEditingController();
  var _whoController = TextEditingController();
  var _priceController = TextEditingController();

  List _listagem=[];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255,153,153,10),
          title: Text('To List'),
          titleSpacing: 15,
          actions: [
            _PopupMenuButton(),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async{
                var itens = _listagem.reduce((value, element) => value + '\n' + element);
                SocialShare.shareWhatsapp("For Share:\n" + itens).then((data)
                {
                  print(data);
                });
              },
            )
          ],
        ),
        //Data about the List
        body: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              for (int i = 0; i < _listagem.length; i++)
                ListTile(
                    leading: ExcludeSemantics(
                        child: CircleAvatar(child:Text('${i + 1}'),
                            backgroundColor: Color.fromRGBO(255,153,153,10),
                            foregroundColor: Colors.white,
                            maxRadius: 17,
                            )
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        //Name of the bottons in the row
                        _listItemName(i),
                        _listwhoController(i),
                        _listItemPrice(i),
                        _listDelete(i),
                      ],
                    )
                ),
            ],
          ),
        ),

        //About the floating button ADD in the bottom of the page
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_shopping_cart,color: Colors.white, size: 25),
          backgroundColor: Color.fromRGBO(255,153,153,10),
          onPressed: () => _displayDialog(), //_displayDialog is the fuction for create the new thing in the list
        ),
      ),
    );
  }
// Carregando o tema salvo pelo usuário
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = (prefs.getString('theme') ?? 'Light');
      _themeData = _theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
    });
  }
// Carregando o tema salvo pelo usuário
  _setTheme(theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = theme;
      _themeData = theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
      prefs.setString('theme', theme);
    });
  }

  //Menu Change Theme
  _PopupMenuButton(){
    return PopupMenuButton(
      onSelected: (value) => _setTheme(value) ,
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
              child: Text("Theme Configuration")
          ),
        );
        list.add(
          PopupMenuDivider(
            height: 10,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text("Light"),
            value: 'Light',
            checked: _theme == 'Light',
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text("Dark"),
            value: 'Dark',
            checked: _theme == 'Dark',
          ),
        );
        return list;
      },
    );
  }

  //Label Name
  _listItemName(int i)
  {
    return Expanded(
      child: Text(
          _listagem[i].nomeitem.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          )
      ),
    );
  }
  //Label who is the person?
  _listwhoController(int i)
  {
    return Expanded(
      child: Text(
          _listagem[i].pessoa.toString(),
          style: TextStyle(
            fontSize: 17,
          )
      ),
    );
  }
  //Label Price
  _listItemPrice(int i)
  {
    String text = _listagem[i].preco != null ? "R\$ "+_listagem[i].preco.toStringAsFixed(2) : "";
    return Expanded(
      child: Text(
          text
      ),
    );
  }
  //Botton Remove: Remove something in the list
  _listDelete(int i)
  {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 22.0,
        color: Colors.cyan,
      ),
      onPressed: (){
        setState(() {
          _controller.delete(i).then((data) {
            setState(() {
              _listagem = _controller.list;
            });
          });
        });
      },
    );
  }

  //About the new item at the list
  _displayDialog() async {
    final context = _navigatorKey.currentState.overlay.context;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameitemController,
                          validator: (s) {
                            if (s.length < 2)
                              return "Please, type the item with less 2 character's";
                            else
                              return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: "Name of the Item*"),
                        ),
                        TextFormField(
                          controller: _whoController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: "Who is the person"),
                        ),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Price", prefixText: "R\$ "),
                        ),
                      ],
                    )
                )
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                     /* _listagem.add({
                        "name": _nameitemController.text,
                        "who": _whoController.text,
                        "price": double.tryParse(_priceController.text) ?? 0,
                      });*/
                      _controller.create(Item(
                          nomeitem: _nameitemController.text,
                          pessoa: _whoController.text,
                          preco: double.tryParse(_priceController.text) ?? 0
                      ));
                      _nameitemController.text = "";
                      _whoController.text = "";
                      _priceController.text = "";
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

}
