import 'package:flutter/material.dart';

/// Widget que exibe o certificado visual
class CertificadoWidget extends StatelessWidget {
  const CertificadoWidget({
    super.key,
    required this.nomeAluno,
    required this.tituloCurso,
    required this.nomeInstrutor,
    required this.dataConclusao,
    required this.cargaHoraria,
    required this.codigoCertificado,
  });

  final String nomeAluno;
  final String tituloCurso;
  final String nomeInstrutor;
  final String dataConclusao;
  final String cargaHoraria;
  final String codigoCertificado;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.414, // Proporcao A4
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF1A365D),
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              // Borda decorativa interna
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // Conteudo
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // Icone
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 40,
                        color: Color(0xFFD4AF37),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Titulo
                    const Text(
                      'CERTIFICADO',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A365D),
                        letterSpacing: 8,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'DE CONCLUSAO',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5568),
                        letterSpacing: 4,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Certificamos que
                    const Text(
                      'Certificamos que',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Nome do aluno
                    Text(
                      nomeAluno,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A365D),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Texto descritivo
                    Text(
                      'concluiu com exito o curso',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Nome do curso
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A365D).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tituloCurso,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A365D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Info adicional
                    if (cargaHoraria.isNotEmpty)
                      Text(
                        'Carga horaria: $cargaHoraria',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Linha divisoria
                    Container(
                      width: 100,
                      height: 1,
                      color: const Color(0xFFD4AF37),
                    ),

                    const SizedBox(height: 8),

                    // Instrutor
                    if (nomeInstrutor.isNotEmpty) ...[
                      Text(
                        nomeInstrutor,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A365D),
                        ),
                      ),
                      Text(
                        'Instrutor',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],

                    const Spacer(flex: 1),

                    // Data e codigo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data de conclusao',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(
                              dataConclusao,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Codigo de verificacao',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(
                              codigoCertificado,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selo decorativo
              Positioned(
                bottom: 40,
                right: 40,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.verified,
                      color: Color(0xFFD4AF37),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botoes de acao do certificado
class CertificadoActions extends StatelessWidget {
  const CertificadoActions({
    super.key,
    required this.onCompartilhar,
    required this.onBaixar,
  });

  final VoidCallback onCompartilhar;
  final VoidCallback onBaixar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCompartilhar,
              icon: const Icon(Icons.share),
              label: const Text('Compartilhar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onBaixar,
              icon: const Icon(Icons.download),
              label: const Text('Baixar PDF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
