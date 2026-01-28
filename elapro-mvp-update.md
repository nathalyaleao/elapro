# Plano de Implementação: Atualização MVP ElaPro (Foco Agendamento)

Foco: Transformar o ElaPro em um web-app de gestão ágil para empreendedoras solo, com foco total em agendamento e usabilidade.

## 🛠 1. Infraestrutura e Arquitetura

- **Estado:** Implementar MobX para gerenciamento de estado reativo.
- **Arquitetura:** Seguir Clean Architecture (Data, Domain, Presentation).
- **Backend:** Preparar estrutura para Firebase (Firestore).
- **Dependências:** Adicionar `mobx`, `flutter_mobx`, `mobx_codegen`, `firebase_core`, `cloud_firestore`.

## 📋 2. Tarefas por Módulo

### A. Core & Onboarding
- [ ] Desabilitar módulo "Orçamentista" no `OnboardingFlowScreen`.
- [ ] Configurar injeção de dependência (ou Singleton para Stores MobX).

### B. Gestão de Clientes (Simplificada)
- [ ] Criar Model `Client` (id, name, whatsapp).
- [ ] Criar `ClientStore` para gerenciar a lista de clientes.
- [ ] **Novo Agendamento:** Implementar seletor de cliente com opção "Novo Cliente Rápido" (apenas Nome e WhatsApp).
- [ ] **Tela de Detalhes:** Adicionar seção de Histórico e botão "Agendar Novamente".

### C. Gestão de Serviços (Limpeza Visual)
- [ ] Simplificar Model `Service` (name, price, duration).
- [ ] Reformular formulário de cadastro de serviços (remover campos extras).
- [ ] Garantir que a `duration` seja usada para o cálculo de término do agendamento.

### D. Agenda e Conflitos
- [ ] Criar Model `Appointment`.
- [ ] Implementar `ScheduleStore` com lógica de verificação de disponibilidade (overlap check).
- [ ] **UI:** Mostrar alerta vermelho em caso de conflito e bloquear o botão "Salvar".

### E. Automação WhatsApp
- [ ] Criar componente `WhatsAppButton`.
- [ ] Implementar gerador de link dinâmico: `https://wa.me/55[TELEFONE]?text=[MENSAGEM]`.

### F. Financeiro Básico
- [ ] Criar `SettingsStore` para salvar taxas de maquininha (% Débito, % Crédito, % Pix).
- [ ] **Lógica de Pagamento:** Calcular `valorLiquido = valorBruto * (1 - taxa)`.
- [ ] **Dashboard:** Atualizar cards de faturamento para destacar o Valor Líquido.

## 🚀 Próximos Passos

1. Atualizar `pubspec.yaml`.
2. Criar modelos de dados e Stores MobX.
3. Refatorar telas de Agendamento e Serviços.
4. Implementar lógica de taxas e financeiro.
5. Rodar testes e validação final.
