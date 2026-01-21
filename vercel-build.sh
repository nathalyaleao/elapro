#!/bin/bash

# Instala o Flutter (versão estável)
git clone https://github.com/flutter/flutter.git -b stable

# Adiciona o Flutter ao PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Mostra a versão para conferência
flutter --version

# Habilita o suporte web
flutter config --enable-web

# Baixa as dependências
flutter pub get

# Constrói a versão de produção para Web
flutter build web --release
