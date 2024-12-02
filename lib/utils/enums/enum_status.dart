enum ObjectStatus {
  NOT_STARTED,
  IN_ANALYSIS,
  IN_PROGRESS,
  IN_TESTS,
  DONE,
  CANCELED,
  PAUSE;

  String getDescription() {
    switch (this) {
      case ObjectStatus.NOT_STARTED:
        return "Não Iniciado";
      case ObjectStatus.IN_ANALYSIS:
        return "Em Análise";
      case ObjectStatus.IN_PROGRESS:
        return "Em Progresso";
      case ObjectStatus.IN_TESTS:
        return "Em Teste";
      case ObjectStatus.DONE:
        return "Finalizado";
      case ObjectStatus.CANCELED:
        return "Cancelado";
      case ObjectStatus.PAUSE:
        return "Pause";
    }
  }

  getObjectStatus(String description) {
    switch (description) {
      case "Não Iniciado":
        return NOT_STARTED;
      case "Em Análise":
        return IN_ANALYSIS;
      case "Em Progresso":
        return IN_PROGRESS;
      case "Em Teste":
        return IN_TESTS;
      case "Finalizado":
        return DONE;
      case "Cancelado":
        return CANCELED;
      case "Pause":
        return PAUSE;
    }
  }

  static String getStringToJson(String description) {
    switch (description) {
      case "Não Iniciado":
        return "NOT_STARTED";
      case "Em Análise":
        return "IN_ANALYSIS";
      case "Em Progresso":
        return "IN_PROGRESS";
      case "Em Teste":
        return "IN_TESTS";
      case "Finalizado":
        return "DONE";
      case "Cancelado":
        return "CANCELED";
      case "Pause":
        return "PAUSE";
      default:
        return "NOT_STARTED";
    }
  }

  static String getOsToString(String description) {
    switch (description) {
      case "NOT_STARTED":
        return "Não Iniciado";
      case "IN_ANALYSIS":
        return "Em Análise";
      case "IN_PROGRESS":
        return "Em Progresso";
      case "IN_TESTS":
        return "Em Teste";
      case "DONE":
        return "Finalizado";
      case "CANCELED":
        return "Cancelado";
      case "PAUSE":
        return "Pause";
      default:
        return "Não Iniciado";
    }
  }
}
