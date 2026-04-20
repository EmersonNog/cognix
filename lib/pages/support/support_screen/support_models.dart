part of '../support_screen.dart';

class _SupportFaqItem {
  const _SupportFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

const _supportFaqItems = <_SupportFaqItem>[
  _SupportFaqItem(
    question: 'Como recuperar o acesso à conta?',
    answer:
        'Se você perdeu o acesso, siga este fluxo:\n'
        '- abra a tela de login\n'
        '- toque em "Esqueci minha senha"\n'
        '- informe o email usado no cadastro\n'
        '- siga as instruções enviadas para redefinir sua senha\n\n'
        'Se o email não chegar, confira spam, lixo eletrônico e se o endereço digitado está correto.',
  ),
  _SupportFaqItem(
    question: 'Onde ajusto minhas metas de estudo?',
    answer:
        'Você pode ajustar o plano direto da tela de "Início":\n'
        '- toque em "Abrir plano"\n'
        '- revise ritmo semanal e frequência\n'
        '- ajuste volume de minutos e meta de questões\n'
        '- escolha o foco que deve guiar sua rotina\n\n'
        'As alterações passam a influenciar como o app apresenta seu planejamento e a leitura da semana.',
  ),
  _SupportFaqItem(
    question: 'Como as recomendações são definidas?',
    answer:
        'As recomendações usam uma combinação de sinais do seu estudo:\n'
        '- desempenho recente por área de conhecimento e disciplina\n'
        '- pontos de atenção onde seu acerto está mais sensível\n'
        '- prioridades salvas no seu plano de estudo\n'
        '- frentes com pouca cobertura no seu histórico\n\n'
        'A ideia é sugerir o próximo passo com mais impacto no momento, e não apenas repetir os mesmos temas aleatoriamente.',
  ),
  _SupportFaqItem(
    question: 'O que entra no desempenho recente?',
    answer:
        'A seção de desempenho recente considera sessões concluídas e mostra um resumo rápido do que acabou de acontecer:\n'
        '- percentual de acerto da sessão\n'
        '- quantidade de respostas corretas\n'
        '- tempo relativo de conclusão, como "há 5 min"\n'
        '- a tentativa mais recente de cada frente estudada\n\n'
        'Se você refizer a mesma disciplina, o app prioriza a tentativa mais nova em vez de empilhar resultados antigos.',
  ),
  _SupportFaqItem(
    question: 'Por que uma recomendação pode aparecer de novo?',
    answer:
        'Isso pode acontecer quando aquela frente continua relevante para o seu momento:\n'
        '- a disciplina ainda está com baixa precisão\n'
        '- ela segue como prioridade no seu plano\n'
        '- ainda existe pouca cobertura de questões naquele tema\n\n'
        'As recomendações não funcionam como uma fila fixa. Elas são recalculadas com base no seu estado atual de estudo.',
  ),
  _SupportFaqItem(
    question: 'Como a sequência de estudos funciona?',
    answer:
        'A sequência acompanha quantos dias seguidos você manteve atividade de estudo:\n'
        '- responder questões ou concluir simulados conta como atividade\n'
        '- a contagem cresce dia após dia quando existe continuidade\n'
        '- se você ficar sem atividade, a sequência pode ser interrompida\n\n'
        'No Início, o número principal mostra sua sequência atual e o calendário semanal ajuda a visualizar os dias recentes.',
  ),
];
