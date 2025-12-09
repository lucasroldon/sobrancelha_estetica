# Widgets Reutilizáveis

## PrimaryButton

Botão padrão moderno com animação de escala ao toque.

### Uso Básico

```dart
PrimaryButton(
  label: 'Continuar',
  onPressed: () {
    // Ação do botão
  },
)
```

### Com Ícone

```dart
PrimaryButton(
  label: 'Salvar',
  icon: Icons.save,
  onPressed: () {
    // Ação do botão
  },
)
```

### Com Loading

```dart
PrimaryButton(
  label: 'Enviar',
  isLoading: true,
  onPressed: () {
    // Ação do botão
  },
)
```

### Personalizado

```dart
PrimaryButton(
  label: 'Customizado',
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  width: 200,
  height: 60,
  padding: EdgeInsets.all(20),
  onPressed: () {
    // Ação do botão
  },
)
```

## AnimatedPageWrapper

Adiciona animação de entrada e saída em qualquer tela.

### Uso Básico

```dart
AnimatedPageWrapper(
  child: YourScreen(),
)
```

### Tipos de Animação

```dart
// Fade (apenas opacidade)
AnimatedPageWrapper(
  animationType: AnimationType.fade,
  child: YourScreen(),
)

// Slide (apenas movimento)
AnimatedPageWrapper(
  animationType: AnimationType.slide,
  child: YourScreen(),
)

// Fade + Slide (padrão)
AnimatedPageWrapper(
  animationType: AnimationType.fadeSlide,
  child: YourScreen(),
)

// Scale (escala + fade)
AnimatedPageWrapper(
  animationType: AnimationType.scale,
  child: YourScreen(),
)
```

### Personalizar Duração e Curva

```dart
AnimatedPageWrapper(
  duration: Duration(milliseconds: 600),
  curve: Curves.easeOut,
  child: YourScreen(),
)
```

