/// Constantes de strings para o módulo Desafio 21 Dias
///
/// Centraliza todas as strings usadas no módulo para facilitar:
/// - Manutenção e atualização de textos
/// - Tradução futura (i18n)
/// - Consistência de mensagens
class DesafioStrings {
  // Título do desafio
  static const String desafioTitle = 'Desafio 21 dias';

  // Mensagens de status de meditação
  static const String waitNextDay = 'Precisa aguardar o próximo dia para fazer esta meditação';
  static const String completePreviousDay = 'Você precisa completar o dia anterior primeiro.';

  /// Retorna mensagem de aguardar até uma data específica
  static String waitUntilDate(String formattedDate) => 'Aguarde até $formattedDate para iniciar o desafio.';

  // Mensagens de conclusão
  static const String congratulations = 'Parabéns!';
  static const String challengeCompleted = 'Você completou o Desafio 21 dias!';

  // Mensagens de erro
  static const String meditationNotFound = 'Meditação não encontrada';
  static const String errorLoadingData = 'Erro ao carregar dados do desafio';

  // Botões e ações
  static const String startChallenge = 'Iniciar Desafio';
  static const String continueChallenge = 'Continuar';
  static const String resetChallenge = 'Reiniciar Desafio';
  static const String viewRewards = 'Ver Conquistas';
  static const String downloadAudio = 'Baixar Áudio';

  // Diário de meditação
  static const String meditationDiary = 'Diário de meditação';
  static const String completedOn = 'Concluída em';

  // Etapas e dias
  static String dayNumber(int day) => 'Dia $day';
  static String stageNumber(int stage) => 'Etapa $stage';

  // Brasões
  static const String bronzeBadge = 'Bronze';
  static const String silverBadge = 'Prata';
  static const String goldBadge = 'Ouro';

  // Mensagens de confirmação
  static const String confirmResetTitle = 'Reiniciar Desafio?';
  static const String confirmResetMessage =
      'Tem certeza que deseja reiniciar o desafio? Todo o seu progresso será perdido.';
  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';

  // Tooltips e dicas
  static const String audioNotDownloaded = 'Áudio não baixado';
  static const String downloadAudioFirst = 'Baixe o áudio antes de iniciar a meditação';

  // Status de progresso
  static String daysCompleted(int days) => '$days dias completados';
  static String stagesCompleted(int stages) => '$stages etapas completadas';

  // Onboarding
  static const String welcomeToChallenge = 'Bem-vindo ao Desafio 21 Dias';
  static const String onboardingDescription = 'Transforme sua vida em 21 dias de meditação guiada';

  // Construtor privado para prevenir instanciação
  DesafioStrings._();
}
