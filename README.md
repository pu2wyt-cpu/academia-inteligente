# Academia Inteligente — FitPulse

Aplicação web responsiva para gestão de academia, acompanhamento de alunos, treinos, nutrição e evolução física.

## Tecnologias
- React + TypeScript
- Vite
- Lucide React
- CSS responsivo com identidade visual escura

## Executar localmente
```bash
npm install
npm run dev
```

Para gerar a versão de produção:
```bash
npm run build
npm run preview
```

## Estado atual
Esta primeira entrega implementa a base visual e navegável:
- Dashboard administrativo com indicadores e gráficos ilustrativos.
- Navegação entre visão geral, alunos, treinos, nutrição e avaliações.
- Cadastro demonstrativo de aluno com objetivo e peso inicial.
- Visão do aluno com resumo de metas e treino do dia.
- Layout adaptado para desktop, tablet e celular.

Os dados desta versão são locais e demonstrativos. Ainda não há autenticação real, banco de dados, persistência entre dispositivos, cobrança, notificações ou integração com IA.

## Próximas etapas recomendadas
1. Definir banco de dados e autenticação com papéis (administrador, professor e aluno).
2. Implementar onboarding completo: idade, altura, peso, experiência, objetivo, disponibilidade, equipamentos, medidas e restrições.
3. Construir editor de treinos, biblioteca de exercícios e geração assistida por IA com revisão profissional.
4. Construir planos alimentares individuais com autoria e aprovação de profissional habilitado.
5. Implementar avaliações periódicas, histórico, gráficos e consentimento para fotos.
6. Aplicar controles de acesso, proteção de dados e requisitos da LGPD.

## Segurança e responsabilidade
Sugestões automatizadas de treino e alimentação não substituem avaliação profissional. Treinos e planos alimentares devem ser revisados por profissionais habilitados antes de serem atribuídos. Não inserir dados reais de saúde ou informações pessoais nesta versão demonstrativa.
