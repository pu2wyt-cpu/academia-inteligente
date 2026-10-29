# Academia Inteligente — FitPulse

Aplicação web responsiva para gestão de academia, acompanhamento individual, treinos, nutrição e avaliações físicas.

## Tecnologias
- React + TypeScript + Vite
- Lucide React
- CSS responsivo, tema escuro
- Persistência local no navegador (localStorage), nesta etapa

## Módulos implementados
- Painel administrativo com contadores reais dos registros locais.
- Cadastro de aluno com idade, altura, peso, experiência, objetivo, frequência semanal, duração, equipamentos e limitações.
- Busca e seleção de alunos com resumo do perfil.
- Cadastro de programas de treino com aluno, foco, dias, exercício, séries, repetições, descanso e carga/observação.
- Fluxo de rascunho e aprovação de treino.
- Cadastro de planos alimentares por aluno, com refeições, horários e orientações.
- Fluxo de rascunho e aprovação de plano alimentar.
- Avaliação física com peso, cintura, peito, quadril, braço, coxa e observações.
- Atualização do peso atual do aluno ao registrar avaliação.
- Área do aluno para visualizar apenas treinos e orientações aprovados.
- Interface responsiva para celular e desktop.

## Executar localmente
```bash
npm install
npm run dev
```

Build de produção:
```bash
npm run build
npm run preview
```

## Limitações importantes desta etapa
Os registros são salvos no navegador atual via localStorage. Ainda não existe banco de dados compartilhado, autenticação real, perfis de acesso seguros, sincronização entre dispositivos, armazenamento de fotos, notificações ou integração com IA. O seletor Admin/Aluno é apenas uma demonstração visual, não um controle de segurança. Não use dados reais sensíveis até a implantação de autenticação e backend seguros.

## Próximas etapas
1. Backend e banco de dados (por exemplo, Supabase) com migrações e regras de acesso por perfil.
2. Autenticação e recuperação de senha; papéis reais de administrador, professor e aluno.
3. Editor avançado com múltiplos exercícios por ficha, biblioteca de exercícios e histórico de cargas.
4. Histórico e gráficos de evolução física, consentimento e armazenamento seguro de imagens.
5. Integração de IA para sugestões de treino com validação e aprovação profissional.
6. Gestão de planos, pagamentos, agenda, notificações e auditoria.
7. Revisão de segurança, privacidade e conformidade com a LGPD.

## Segurança e responsabilidade
Sugestões automatizadas não substituem avaliação profissional. Treinos devem ser revisados por profissional de educação física habilitado. Planos alimentares individualizados devem ser elaborados e aprovados por nutricionista habilitado. O sistema não fornece diagnóstico nem prescrição clínica.
