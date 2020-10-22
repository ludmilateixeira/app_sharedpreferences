class Item {
  String nomeitem, pessoa;
  double preco;

  Item({this.nomeitem, this.pessoa, this.preco});

  Item.fromJson(Map<String, dynamic> json) {
    nomeitem = json['nomeitem'];
    pessoa = json['pessoa'];
    preco = json['preco'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomeitem'] = this.nomeitem;
    data['pessoa'] = this.pessoa;
    data['preco'] = this.preco;
    return data;
  }
}