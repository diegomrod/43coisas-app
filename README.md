43coisas-app
============

Um pequeno aplicativo em javascript, que permite que você registre "coisas que não deveriam existir" e obter as coisas mais citadas pelos usuário de um site. O app foi instalado em um site wordpress e fez uma integração com a base de dados do site. Registrando o usuário que digitou a coisa pela primeira vez.

O código utiliza-se da classe built-in EventEmitter, que permite atrelar eventos async e performar request e queries muito mais rápido que de maneira sync. Faz uso do event loop do Node de maneira muito melhor do que o usado no E-commerce Node.
