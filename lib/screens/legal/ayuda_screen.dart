import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  static const _faqs = [
    _FAQ(
      pregunta: '¿Qué es IN MEMORIAM?',
      respuesta:
          'IN MEMORIAM es una red social diseñada para informar sobre fallecimientos en tu zona y permitir a familiares, amigos y conocidos dejar condolencias, flores virtuales y recuerdos en honor a la persona fallecida.',
    ),
    _FAQ(
      pregunta: '¿Necesito registrarme para ver los fallecidos?',
      respuesta:
          'No. Cualquier persona puede navegar por el feed y ver la información de los fallecidos sin necesidad de crear una cuenta. El registro solo es necesario para interactuar: dejar condolencias, enviar flores o publicar recuerdos.',
    ),
    _FAQ(
      pregunta: '¿Cómo se publica un fallecimiento?',
      respuesta:
          'Las publicaciones de fallecidos pueden realizarlas los tanatorios registrados como entidades verificadas, o los propios familiares a través de su cuenta. Todas las publicaciones pasan por un proceso de verificación antes de aparecer en el feed.',
    ),
    _FAQ(
      pregunta: '¿Quién puede publicar una esquela?',
      respuesta:
          'Cualquier usuario registrado puede publicar una esquela vinculada a un fallecido. Los tanatorios verificados tienen un sello especial. Todas las esquelas son revisadas antes de su publicación.',
    ),
    _FAQ(
      pregunta: '¿Por qué mis comentarios no aparecen inmediatamente?',
      respuesta:
          'Todos los comentarios pasan por una moderación previa para garantizar que el contenido sea respetuoso y apropiado. Este proceso puede tardar algunas horas. Recibirás una notificación cuando tu comentario sea aprobado.',
    ),
    _FAQ(
      pregunta: '¿Cómo se moderan los comentarios?',
      respuesta:
          'Contamos con un equipo de moderación que revisa todos los comentarios antes de publicarlos. Los mensajes inapropiados, ofensivos o que no guarden relación con la finalidad de la plataforma serán rechazados.',
    ),
    _FAQ(
      pregunta: '¿Puedo enviar flores virtuales sin cuenta?',
      respuesta:
          'No. Para enviar flores virtuales o dejar mensajes personalizados es necesario tener una cuenta activa en IN MEMORIAM. El registro es gratuito y solo tarda unos minutos.',
    ),
    _FAQ(
      pregunta: '¿Cómo puedo filtrar por zona o características?',
      respuesta:
          'En el feed principal, pulsa el icono de filtro en la parte superior derecha. Podrás filtrar por provincia, localidad, rango de edad y fecha de fallecimiento. También puedes usar el buscador para encontrar por nombre.',
    ),
    _FAQ(
      pregunta: '¿Qué pasa con la privacidad de los datos del fallecido?',
      respuesta:
          'Solo se publican datos que han sido autorizados expresamente por un familiar o entidad autorizada (tanatorio). Puedes consultar nuestra Política de Privacidad para más información.',
    ),
    _FAQ(
      pregunta: '¿Cómo solicito la eliminación de una publicación?',
      respuesta:
          'Si eres familiar directo del fallecido y deseas que se retire alguna publicación, puedes contactar con nosotros a través del formulario de contacto o escribiendo a privacidad@inmemoriam.es',
    ),
    _FAQ(
      pregunta: '¿Los tanatorios pagan por publicar?',
      respuesta:
          'IN MEMORIAM tiene un plan gratuito para particulares y planes de suscripción para entidades como tanatorios que deseen acceder a funcionalidades avanzadas como verificación de cuenta o estadísticas.',
    ),
    _FAQ(
      pregunta: '¿Cómo contacto con el soporte?',
      respuesta:
          'Puedes escribirnos a soporte@inmemoriam.es o usar el formulario de contacto dentro de la aplicación. Nuestro equipo atiende de lunes a viernes de 9:00 a 18:00 h.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Ayuda y FAQ'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildCabecera(),
          const SizedBox(height: AppSpacing.lg),
          ..._faqs.map((f) => _FAQTile(faq: f)),
          const SizedBox(height: AppSpacing.lg),
          _buildContacto(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildCabecera() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline, color: AppColors.goldLight, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Preguntas frecuentes',
            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Encuentra respuesta a las dudas más comunes sobre IN MEMORIAM.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContacto() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.goldLight.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.email_outlined, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text('¿No encuentras lo que buscas?', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Escríbenos a soporte@inmemoriam.es y te ayudaremos personalmente.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FAQ {
  final String pregunta;
  final String respuesta;
  const _FAQ({required this.pregunta, required this.respuesta});
}

class _FAQTile extends StatefulWidget {
  final _FAQ faq;
  const _FAQTile({required this.faq});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: _expandido ? AppColors.gold : AppColors.border,
          width: _expandido ? 1.0 : 0.5,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _expandido
                          ? AppColors.gold
                          : AppColors.goldLight.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        'P',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _expandido ? Colors.white : AppColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.faq.pregunta,
                      style: AppTextStyles.labelLarge,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    _expandido ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expandido)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md + 32, 0, AppSpacing.md, AppSpacing.md),
              child: Text(
                widget.faq.respuesta,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              ),
            ),
        ],
      ),
    );
  }
}
