# RU Smart

RU Smart é um protótipo de aplicativo para gestão inteligente do Restaurante Universitário. A proposta é tornar o acesso ao RU mais organizado, permitindo que o aluno consulte o cardápio, compre uma ficha, gere um QR Code de acesso e avalie a refeição. Do lado da gestão, o sistema permite cadastrar o cardápio, validar fichas e acompanhar relatórios básicos de atendimento e arrecadação.

Este projeto foi desenvolvido como MVP, ou seja, uma versão mínima funcional para demonstrar a ideia, validar o fluxo principal e mostrar que a solução é tecnicamente viável. Ele não deve ser lido como um produto final de produção, mas sim como uma base funcional que já permite navegar, testar os principais recursos e apresentar a proposta em uma demonstração.

## O que o protótipo faz

### Área do aluno

- Cadastro de aluno com nome, matrícula, e-mail e senha.
- Login com Firebase Authentication.
- Redirecionamento automático quando o aluno já está logado.
- Visualização do cardápio cadastrado pela gestão.
- Compra de ficha por uma tela de PIX simulado.
- Geração de ficha com QR Code interno.
- Exibição da janela sugerida de atendimento.
- Bloqueio de compra duplicada no mesmo dia.
- Exibição da ficha ativa ou validada na Home.
- Envio de avaliação da refeição após a ficha ser validada.

### Área da gestão

- Login separado para contas com perfil `admin`.
- Bloqueio para impedir que aluno acesse a gestão.
- Cadastro e atualização do cardápio do dia.
- Validação de fichas compradas pelos alunos.
- Listagem das fichas pendentes de validação.
- Relatórios com fichas vendidas, fichas validadas, fichas pendentes e arrecadação.
- Relatório de avaliações dos alunos, incluindo média de notas, pontos marcados e comentários recentes.

## O que é real e o que é simulado

O app já usa Firebase de verdade para autenticação e banco de dados. Isso significa que usuários, cardápios, fichas, validações, relatórios e avaliações são salvos no Firestore.

Por outro lado, o pagamento PIX ainda é simulado. No MVP, o botão de confirmação da tela de pagamento representa a confirmação do pagamento e libera a ficha no banco. Em uma versão de produção, essa etapa deveria ser feita por um backend seguro integrado a um gateway de pagamento, como Mercado Pago, Efí, PagSeguro ou outro serviço compatível com PIX.

Também é importante observar que o QR Code usado no protótipo é um identificador interno da ficha. Ele serve para demonstrar o fluxo de validação, mas não é um QR Code PIX bancário real.

## Tecnologias utilizadas

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Material Design
- Android SDK

## Estrutura principal do projeto

```txt
lib/
  core/
    app_colors.dart
    app_theme.dart

  models/
    app_user_model.dart
    ticket_model.dart
    menu_model.dart
    feedback_model.dart
    daily_report_model.dart

  services/
    auth_service.dart
    user_service.dart
    ticket_service.dart
    menu_service.dart
    feedback_service.dart
    report_service.dart

  pages/
    splash/
      splash_page.dart

    auth/
      login_page.dart
      register_page.dart

    student/
      student_home_page.dart
      menu_page.dart
      buy_ticket_page.dart
      pix_payment_page.dart
      ticket_qr_page.dart
      feedback_page.dart

    admin/
      admin_login_page.dart
      admin_dashboard_page.dart
      admin_menu_page.dart
      admin_validation_page.dart
      admin_reports_page.dart

  widgets/
    app_logo.dart
    app_card.dart
    fake_qr_code.dart
    info_box.dart
    status_chip.dart
```

A organização foi feita separando tela, regra de negócio, modelo de dados e componentes visuais. A ideia é deixar o projeto mais fácil de explicar, manter e evoluir.

## Modelo de dados no Firestore

O app trabalha principalmente com quatro coleções:

```txt
users/
  uid/
    name
    email
    registration
    role
    createdAt
```

```txt
menus/
  yyyy-MM-dd/
    dateKey
    mainDish
    sideDishes
    vegetarianOption
    dessert
    drink
    allergens
    observations
    updatedAt
    updatedBy
```

```txt
tickets/
  yyyy-MM-dd_uid/
    userId
    userName
    userEmail
    registration
    dateKey
    date
    mealType
    price
    status
    qrCode
    queuePosition
    suggestedStartTime
    suggestedEndTime
    createdAt
    validatedAt
```

```txt
feedbacks/
  ticketId/
    ticketId
    userId
    userName
    registration
    mealType
    dateKey
    rating
    selectedTags
    comment
    createdAt
```

## Regras gerais de funcionamento

### Perfis de usuário

Existem dois perfis principais:

```txt
student
admin
```

Alunos são criados pelo próprio app, na tela de cadastro. Administradores devem ser criados manualmente no Firebase, pois não faz sentido um usuário comum conseguir se tornar gestor pelo aplicativo.

### Fichas

Cada aluno pode ter apenas uma ficha ativa por dia. Para evitar duplicidade, o documento da ficha usa um ID baseado na data e no usuário:

```txt
yyyy-MM-dd_uid
```

Os principais status são:

```txt
paid       -> ficha paga/ativa, aguardando validação
validated  -> ficha já validada pela gestão
expired    -> ficha expirada, pensado para evolução futura
```

### Janela sugerida de atendimento

O protótipo calcula uma janela simples com base na posição virtual da ficha. A lógica atual agrupa os alunos em blocos de 20 pessoas, com janelas de 10 minutos, começando às 12:00.

Exemplo:

```txt
Aluno 1 a 20   -> 12:00 - 12:10
Aluno 21 a 40  -> 12:10 - 12:20
Aluno 41 a 60  -> 12:20 - 12:30
```

Essa janela não bloqueia o aluno. Ela serve como sugestão para distribuir melhor a chegada ao RU e reduzir filas.

Em uma versão futura, esse cálculo pode ser melhorado usando tempo real de validação, quantidade de pessoas na frente, velocidade média de atendimento e horários configuráveis pela gestão.

## Pré-requisitos

Antes de rodar o projeto, é necessário ter instalado:

- Flutter SDK
- Dart SDK, que já vem junto com o Flutter
- Android Studio ou Android SDK configurado
- Um emulador Android ou celular físico com depuração USB ativada
- Conta no Firebase
- Projeto Firebase configurado com Authentication e Firestore

Para conferir se o Flutter está instalado corretamente, rode:

```bash
flutter doctor
```

Se aparecer algum problema relacionado ao Android SDK, aceite as licenças com:

```bash
flutter doctor --android-licenses
```

## Como rodar o projeto

Depois de clonar ou baixar o projeto, entre na pasta raiz:

```bash
cd rusmart
```

Antes de tentar rodar ou gerar build, baixe as dependências:

```bash
flutter pub get
```

Esse comando é importante porque ele instala os pacotes usados pelo projeto, como Firebase Authentication e Cloud Firestore. Sem ele, o app pode não compilar.

Depois rode:

```bash
flutter run
```

Caso queira limpar arquivos antigos de build antes de rodar novamente:

```bash
flutter clean
flutter pub get
flutter run
```

## Build para Android

Para gerar um APK de teste:

```bash
flutter build apk --debug
```

Para gerar um APK em modo release:

```bash
flutter build apk --release
```

O APK fica em:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

Também é possível gerar APKs separados por arquitetura:

```bash
flutter build apk --release --split-per-abi
```

## Configuração do Firebase

O projeto usa Firebase, então é necessário que o app esteja conectado a um projeto Firebase válido.

### 1. Authentication

No Firebase Console, ative o login por e-mail e senha:

```txt
Authentication
  Sign-in method
    Email/Password
      Enable
```

### 2. Firestore Database

Crie o banco Firestore:

```txt
Firestore Database
  Create database
```

Para teste de desenvolvimento, é possível iniciar em modo de teste. Para apresentação e uso mais controlado, configure regras de segurança adequadas para os perfis `student` e `admin`.

### 3. Arquivo firebase_options.dart

O arquivo abaixo é usado para inicializar o Firebase no Flutter:

```txt
lib/firebase_options.dart
```

Se esse arquivo já estiver no projeto e apontar para o Firebase correto, não é necessário gerar outro.

Se for configurar um novo projeto Firebase, instale e use o FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

No Windows, se o comando `flutterfire` não for reconhecido, rode pelo caminho completo:

```powershell
& "$env:LOCALAPPDATA\Pub\Cache\bin\flutterfire.bat" configure
```

Depois disso, confira se o arquivo `lib/firebase_options.dart` foi criado ou atualizado.

## Criando uma conta de aluno

O aluno pode ser criado diretamente pelo aplicativo:

1. Abra o app.
2. Vá em criar conta.
3. Informe nome, matrícula, e-mail e senha.
4. Entre no app com os dados cadastrados.

O app cria o usuário no Firebase Authentication e também cria o perfil em `users/{uid}` com `role: student`.

## Criando uma conta de gestão

A conta de gestão precisa ser criada manualmente no Firebase.

### 1. Criar usuário no Authentication

No Firebase Console:

```txt
Authentication
  Users
    Add user
```

Exemplo para teste:

```txt
E-mail: admin@rusmart.com
Senha: 123456
```

Depois de criar o usuário, copie o UID gerado pelo Firebase.

### 2. Criar perfil no Firestore

No Firestore, crie um documento na coleção `users` usando exatamente o UID do usuário admin como ID do documento.

Campos:

```txt
name: Administrador RU Smart
email: admin@rusmart.com
registration: 
role: admin
createdAt: timestamp
```

O campo `registration` pode ficar vazio para a gestão.

Se o login da gestão mostrar a mensagem `Perfil da gestão não encontrado no Firestore`, normalmente o documento foi criado com ID diferente do UID. Se mostrar `Esta conta não tem permissão de gestão`, confira se o campo `role` está exatamente como `admin`.

## Roteiro sugerido para demonstração

Um fluxo simples para apresentar o MVP:

1. Abrir o app.
2. Criar ou acessar uma conta de aluno.
3. Mostrar a Home do aluno, com cardápio e status da ficha.
4. Abrir a tela de cardápio.
5. Comprar uma ficha.
6. Passar pela tela de PIX simulado.
7. Mostrar o QR Code da ficha e a janela sugerida.
8. Sair do aluno e entrar na gestão.
9. Cadastrar ou atualizar o cardápio do dia.
10. Abrir a validação de fichas.
11. Validar a ficha do aluno.
12. Abrir os relatórios da gestão.
13. Voltar no aluno e enviar uma avaliação da refeição.
14. Mostrar a avaliação aparecendo nos relatórios.

Esse roteiro demonstra o ciclo completo: aluno compra, gestão valida, sistema registra e relatório acompanha.

## Limitações conhecidas do MVP

Algumas partes foram mantidas simples de propósito, porque o foco do MVP é demonstrar a solução funcionando:

- O pagamento PIX é simulado.
- Não há integração real com banco, gateway ou webhook de pagamento.
- O QR Code é visual/interno, usado para representar a ficha no protótipo.
- O cálculo de horário sugerido é fixo e baseado em posição virtual.
- Não há painel avançado de estoque.
- Não há notificações push automáticas.
- Não há backend próprio ou Cloud Functions para processamentos sensíveis.

Esses pontos não impedem a demonstração do MVP, mas mostram caminhos naturais para evolução do projeto.

## Possíveis melhorias futuras

- Integração real com PIX usando gateway de pagamento.
- Webhook para confirmar pagamento automaticamente.
- Criação de ficha somente após confirmação real do pagamento.
- Cálculo dinâmico de fila com base na velocidade real de validação.
- Notificações para lembrar o aluno da janela sugerida.
- Controle de estoque e insumos do RU.
- Relatórios por semana, mês e período customizado.
- Exportação de relatórios em PDF ou planilha.
- Perfis administrativos mais específicos, como nutricionista, caixa e financeiro.
- Leitor real de QR Code usando câmera.
- Testes automatizados.

## Problemas comuns

### O app não compila depois de baixar o projeto

Rode:

```bash
flutter pub get
```

Se ainda assim não funcionar:

```bash
flutter clean
flutter pub get
flutter run
```

### O Firebase não inicializa

Confira se existe o arquivo:

```txt
lib/firebase_options.dart
```

Também confira se o `main.dart` inicializa o Firebase antes de chamar o app.

### Login por e-mail e senha não funciona

No Firebase Console, verifique se o provedor Email/Password está ativado em Authentication.

### A gestão não consegue entrar

Verifique três coisas:

1. O usuário existe em Authentication.
2. Existe um documento em `users/{uid}` com o mesmo UID.
3. O campo `role` está como `admin`.

### Erro permission-denied no Firestore

Esse erro normalmente está ligado às regras de segurança do Firestore ou ao perfil do usuário. Confira se o usuário logado tem o papel correto e se as regras permitem a leitura/escrita esperada.

## Observação sobre o objetivo do projeto

O RU Smart foi pensado como uma solução para melhorar a experiência no Restaurante Universitário, reduzindo filas, organizando melhor o fluxo de atendimento e dando mais dados para a gestão. O protótipo mostra esse caminho de forma prática: o aluno consegue interagir com o app, a gestão consegue acompanhar o uso, e os dados principais ficam registrados no Firebase.

O projeto ainda pode evoluir bastante, principalmente na parte de pagamento real, estimativa inteligente de fila e relatórios avançados. Mesmo assim, o MVP já apresenta a lógica central da solução e permite uma demonstração funcional do problema, da proposta e do valor do sistema.
