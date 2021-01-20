class ProdutoValidacao {

String validationImages(List images) {
    if(images.isEmpty) return "Adcione imagens do produto";
    return null;
}
String validationTitulo(String texto){
  if(texto.isEmpty) return "Preencha o titulo do produto";
  return null;
}

String validationDescricao(String texto){
  if(texto.isEmpty) return "Preencha imagens do produto";
  return null;
}
String validationPreco(String texto){
  double preco = double.tryParse(texto);
  if(preco != null) {
    if(!texto.contains(".") || texto.split(".")[1].length != 2)
      return "Utilizar 2 casas decimais";
  } else {
    return "Preço inválido";
  }
  return null;
}


}
