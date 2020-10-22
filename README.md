# To Note and Share / Para Anotar e Compartilhar
<p>Terceiro desenvolvimento de um app em Flutter/Dart.</p>
<p><b>Vídeo: <a href="">Clique aqui!</a></b></p>

## Visão Geral
<p align="justify">Uma extensão do app prévio <a href="https://github.com/ludmilateixeira/lista_app">"To Buy and Share / Para Comprar e Compartilhar"</a>, este app possui as mesmas funcionalidades de seu antecessor, com novas atualizações: 
<br/>
O app agora salva automaticamente (persiste) todo o conteúdo da lista de compras em um arquivo json, que é lido durante a inicialização do app. Ou seja, os itens da lista não são perdidos depois que o app é fechado.</p>
<p align="justify">Também foi adicionada a opção de escolha entre os temas Light e Dark para o app. Esta informação também é persistida, porém ela é salva através do plugin Shared Preferences.</p>
<p align="justify">Em quesito técnico, o app passou a ser organizado seguindo o padrão Model–view–controller (MVC). Com isso, o APP foi divido nas seguintes camadas:</p>
<ul>
<li><b>Model</b>: Contendo a classe Item com seus atributos: nome, preço e quem é o responsável, funções que transformam a instância da classe em um objeto json e vice-versa;</li>
<li><b>View</b>: Contendo a classe View onde estão todos os métodos de layout e design do app;</li>
<li><b>Controller</b>: Contendo a classe Controlle, que controla o fluxo dos dados, possuindo as funções de insert, update e delete (CRUD);</li>
<li><b>Repository</b>: Contendo a classe Repository, onde ficam os métodos que envolvem o acesso direto ao banco de dados (o arquivo data.json nesse caso).</li>
</ul> 
<br/>
O app possibilita a adição do item, com possibilidade de inserção do valor e da pessoa responsável pelo item, contudo, os campos não são obrigatórios, trazendo assim mais praticidade.
Até mais!
