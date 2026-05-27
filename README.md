# RU Smart

<p align="center">
  <img src="docs/logo-rusmart.png" alt="Logo do RU Smart" width="140">
</p>

<h1 align="center">RU Smart</h1>

<p align="center">
  Aplicativo MVP para organizar o acesso ao Restaurante Universitário, permitindo compra de ficha, consulta de cardápio, validação por QR Code e acompanhamento pela gestão.
</p>

<p align="center">
  <strong>Baixe o APK pela aba Releases do GitHub e teste sem precisar instalar Flutter ou gerar build.</strong>
</p>

---

## Baixar o aplicativo

Para testar o RU Smart, não é necessário instalar Flutter, Android Studio ou configurar o projeto manualmente.

Siga o passo a passo:

1. Acesse a página do projeto no GitHub.
2. Clique na aba **Releases**.
3. Baixe o arquivo **APK** mais recente.
4. Envie o APK para um celular Android, caso tenha baixado pelo computador.
5. Abra o arquivo no celular.
6. Permita a instalação de apps de fontes desconhecidas, se o Android solicitar.
7. Instale o aplicativo.
8. Abra o **RU Smart** e faça o teste.

> Em alguns celulares, o Android pode exibir um aviso de segurança porque o APK não veio da Play Store. Isso é comum em versões de teste.

---

## Apresentação visual do projeto

### Logo do aplicativo

Coloque a imagem da logo na pasta `docs/` do projeto e use este caminho no README:

```txt
docs/logo-rusmart.png
```

Ela aparece no topo deste README usando:

```html
<img src="docs/logo-rusmart.png" alt="Logo do RU Smart" width="140">
```

### Diagrama de arquitetura

Coloque o diagrama de arquitetura na pasta `docs/` do projeto e use este caminho:

```txt
docs/arquitetura-rusmart.png
```

A imagem deve aparecer logo abaixo:

<p align="center">
  <img src="docs/arquitetura-rusmart.png" alt="Diagrama de arquitetura do RU Smart" width="850">
</p>

O diagrama mostra, de forma simples, como o aluno e a gestão acessam o aplicativo Flutter, que utiliza Firebase Authentication para login e Cloud Firestore para salvar usuários, cardápios, fichas e avaliações.

---

## Sobre o projeto

O **RU Smart** é um protótipo de aplicativo para gestão inteligente do Restaurante Universitário.

A proposta é facilitar a rotina do aluno e da administração do RU, permitindo que o aluno consulte o cardápio, compre uma ficha, gere um QR Code de acesso e avalie a refeição. Do lado da gestão, o sistema permite cadastrar o cardápio, validar fichas e acompanhar relatórios básicos.

Este projeto é um **MVP**, ou seja, uma versão mínima funcional criada para demonstrar a ideia principal e validar o fluxo do sistema. Ele não deve ser entendido como um produto final de produção.

---

## Funcionalidades principais

### Área do aluno

- Cadastro e login com e-mail e senha.
- Consulta do cardápio do dia.
- Compra de ficha por PIX simulado.
- Geração de ficha com QR Code interno.
- Exibição da janela sugerida de atendimento.
- Bloqueio de compra duplicada no mesmo dia.
- Acompanhamento da ficha ativa ou validada.
- Envio de avaliação após a validação da ficha.

### Área da gestão

- Login separado para contas de administrador.
- Cadastro e atualização do cardápio do dia.
- Listagem de fichas pendentes.
- Validação de fichas dos alunos.
- Relatórios de fichas vendidas, validadas, pendentes e arrecadação.
- Relatório de avaliações dos alunos.

---

## Como testar o fluxo principal

Um roteiro simples para demonstração:

1. Abra o aplicativo.
2. Crie ou acesse uma conta de aluno.
3. Veja o cardápio do dia.
4. Compre uma ficha.
5. Confirme o PIX simulado.
6. Veja o QR Code da ficha.
7. Entre na conta de gestão.
8. Valide a ficha do aluno.
9. Confira os relatórios.
10. Volte para a conta do aluno e envie uma avaliação.
11. Veja a avaliação aparecendo nos relatórios da gestão.

Esse fluxo demonstra o ciclo principal do sistema: o aluno compra, a gestão valida, os dados são registrados e os relatórios são atualizados.

---

## Contas de acesso

### Conta de aluno

A conta de aluno pode ser criada diretamente no aplicativo:

1. Abra o app.
2. Toque em **Criar conta**.
3. Informe nome, matrícula, e-mail e senha.
4. Finalize o cadastro.
5. Faça login normalmente.

### Conta de gestão

A conta de gestão precisa estar cadastrada previamente como administrador no Firebase.

Se estiver apenas testando o APK, use as credenciais de administrador informadas pelo responsável do projeto ou na própria página de **Releases**, caso estejam disponíveis.

---

## O que é real e o que é simulado

O aplicativo usa Firebase de verdade para autenticação e banco de dados. Usuários, cardápios, fichas, validações, relatórios e avaliações são salvos no Cloud Firestore.

O pagamento PIX, porém, ainda é simulado. No MVP, o botão de confirmação representa o pagamento e libera a ficha no sistema.

O QR Code também é interno do protótipo. Ele serve para representar a ficha do aluno na validação, mas não é um QR Code PIX bancário real.

---

## Tecnologias utilizadas

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Material Design
- Android

---

## Limitações do MVP

- O PIX é simulado.
- Não há integração real com gateway de pagamento.
- O QR Code é interno do protótipo.
- A janela de atendimento usa cálculo simples.
- Não há leitor real de QR Code pela câmera.
- Não há notificações push.
- Não há painel avançado de estoque.
- Não há backend próprio para processamentos sensíveis.

---

## Melhorias futuras

- Integração real com PIX.
- Confirmação automática de pagamento por webhook.
- Leitor real de QR Code usando câmera.
- Cálculo mais inteligente da fila.
- Notificações para o aluno.
- Controle de estoque do RU.
- Relatórios mais completos.
- Exportação de relatórios em PDF ou planilha.
- Perfis administrativos específicos.
- Testes automatizados.

---

## Observação final

O **RU Smart** foi criado para demonstrar uma solução prática para melhorar a organização do Restaurante Universitário.

Mesmo sendo um MVP, ele já apresenta o fluxo central da proposta: o aluno consulta, compra e avalia; a gestão cadastra, valida e acompanha os dados.

Para testar de forma simples, acesse a aba **Releases** do GitHub e baixe o APK mais recente.
