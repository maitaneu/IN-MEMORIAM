import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Aviso legal y privacidad'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Aviso legal'),
            Tab(text: 'Privacidad'),
            Tab(text: 'Publicaciones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _TabAvisoLegal(),
          _TabPrivacidad(),
          _TabPublicaciones(),
        ],
      ),
    );
  }
}

// ── Tab 1: Aviso legal ─────────────────────────────────────────────
class _TabAvisoLegal extends StatelessWidget {
  const _TabAvisoLegal();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding,
      children: const [
        SizedBox(height: AppSpacing.md),
        _LegalSection(
          titulo: '1. Identificación del titular',
          contenido:
              'En cumplimiento del artículo 10 de la Ley 34/2002, de 11 de julio, de Servicios de la Sociedad de la Información y del Comercio Electrónico (LSSI-CE), se informa que el titular de la plataforma IN MEMORIAM es:\n\n'
              '• Denominación social: IN MEMORIAM S.L.\n'
              '• CIF: B-00000000 (provisional hasta registro definitivo)\n'
              '• Domicilio social: Calle Ejemplo, 1, 28001 Madrid\n'
              '• Email de contacto: legal@inmemoriam.es',
        ),
        _LegalSection(
          titulo: '2. Objeto de la plataforma',
          contenido:
              'IN MEMORIAM es una plataforma digital cuyo objeto es facilitar la difusión de información relativa a fallecimientos, permitir la publicación de esquelas digitales y posibilitar la expresión de condolencias y recuerdos entre personas allegadas al fallecido.',
        ),
        _LegalSection(
          titulo: '3. Condiciones de uso',
          contenido:
              'El acceso y uso de esta plataforma implica la aceptación plena de las presentes condiciones. El usuario se compromete a hacer un uso adecuado de los contenidos y servicios, y en particular a no:\n\n'
              '• Publicar contenidos ofensivos, obscenos o inapropiados.\n'
              '• Utilizar datos personales de terceros sin su consentimiento.\n'
              '• Publicar información falsa sobre personas fallecidas.\n'
              '• Realizar actividades comerciales no autorizadas.\n'
              '• Suplantar la identidad de otras personas o entidades.',
        ),
        _LegalSection(
          titulo: '4. Propiedad intelectual',
          contenido:
              'Todos los contenidos de la plataforma, incluyendo textos, imágenes, logotipos y diseño, son propiedad de IN MEMORIAM S.L. o han sido licenciados a esta. Queda prohibida su reproducción sin autorización expresa.',
        ),
        _LegalSection(
          titulo: '5. Limitación de responsabilidad',
          contenido:
              'IN MEMORIAM no se hace responsable de los contenidos publicados por los usuarios, si bien dispone de un sistema de moderación para garantizar el cumplimiento de las condiciones de uso. Los contenidos inapropiados pueden ser eliminados sin previo aviso.',
        ),
        _LegalSection(
          titulo: '6. Legislación aplicable',
          contenido:
              'Las presentes condiciones se rigen por la legislación española. Para la resolución de cualquier conflicto derivado del uso de la plataforma, las partes se someten a los Juzgados y Tribunales de Madrid, con renuncia expresa a cualquier otro fuero.',
        ),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ── Tab 2: Política de privacidad ──────────────────────────────────
class _TabPrivacidad extends StatelessWidget {
  const _TabPrivacidad();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding,
      children: const [
        SizedBox(height: AppSpacing.md),
        _LegalSection(
          titulo: '1. Responsable del tratamiento',
          contenido:
              'IN MEMORIAM S.L., con domicilio en Calle Ejemplo, 1, 28001 Madrid, es el responsable del tratamiento de los datos personales recogidos a través de esta plataforma.',
        ),
        _LegalSection(
          titulo: '2. Datos que recogemos',
          contenido:
              '• Datos de registro: nombre, apellidos, correo electrónico y contraseña cifrada.\n'
              '• Datos de perfil opcionales: localidad y provincia de residencia.\n'
              '• Contenido generado: comentarios, recuerdos, flores virtuales.\n'
              '• Datos técnicos: dirección IP, tipo de dispositivo, navegador.',
        ),
        _LegalSection(
          titulo: '3. Finalidad del tratamiento',
          contenido:
              '• Gestión de la cuenta de usuario.\n'
              '• Publicación y moderación de contenidos.\n'
              '• Envío de notificaciones relacionadas con la actividad del usuario.\n'
              '• Mejora del servicio y análisis de uso agregado y anónimo.',
        ),
        _LegalSection(
          titulo: '4. Base legal',
          contenido:
              'El tratamiento se realiza sobre la base del consentimiento del interesado (art. 6.1.a RGPD) y la ejecución del contrato de servicios aceptado al registrarse (art. 6.1.b RGPD).',
        ),
        _LegalSection(
          titulo: '5. Conservación de datos',
          contenido:
              'Los datos se conservarán mientras el usuario mantenga su cuenta activa. Tras la baja, los datos serán eliminados en un plazo máximo de 30 días, salvo obligación legal de conservación.',
        ),
        _LegalSection(
          titulo: '6. Derechos del usuario',
          contenido:
              'El usuario tiene derecho a acceder, rectificar, suprimir, limitar el tratamiento, oponerse y solicitar la portabilidad de sus datos. Para ejercer estos derechos, puede escribir a privacidad@inmemoriam.es adjuntando copia de su DNI o documento identificativo.',
        ),
        _LegalSection(
          titulo: '7. Cookies',
          contenido:
              'La plataforma utiliza cookies técnicas necesarias para el funcionamiento del servicio. No se utilizan cookies de seguimiento publicitario sin el consentimiento previo del usuario.',
        ),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ── Tab 3: Autorización de publicaciones ───────────────────────────
class _TabPublicaciones extends StatelessWidget {
  const _TabPublicaciones();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.goldLight.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Este apartado detalla el marco legal y los procedimientos que regulan la publicación de datos relativos a personas fallecidas en IN MEMORIAM.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        const _LegalSection(
          titulo: '1. Marco legal aplicable',
          contenido:
              'La publicación de datos de personas fallecidas está regulada por:\n\n'
              '• Ley Orgánica 3/2018, de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD).\n'
              '• Reglamento General de Protección de Datos (RGPD - UE 2016/679).\n'
              '• Ley Orgánica 1/1982, de protección civil del derecho al honor, a la intimidad personal y familiar y a la propia imagen.\n\n'
              'El RGPD no se aplica a los datos de personas fallecidas (Considerando 27), pero la LOPDGDD española sí permite a los herederos ejercer algunos derechos sobre sus datos.',
        ),
        const _LegalSection(
          titulo: '2. Quién puede publicar datos de un fallecido',
          contenido:
              'La publicación de datos de una persona fallecida solo puede realizarse cuando existe al menos uno de los siguientes supuestos:\n\n'
              '• Consentimiento expreso de un familiar directo (cónyuge, hijos, padres o hermanos).\n'
              '• Publicación por parte de un tanatorio o funeraria que actúe por encargo de la familia.\n'
              '• Información que ya fuera de dominio público y cuya publicación no suponga un perjuicio a los familiares.\n\n'
              'IN MEMORIAM verifica la identidad y relación del publicador con el fallecido antes de aprobar cualquier publicación.',
        ),
        const _LegalSection(
          titulo: '3. Datos que pueden publicarse',
          contenido:
              'Se permite la publicación de:\n\n'
              '• Nombre y apellidos completos.\n'
              '• Fecha y lugar de nacimiento y fallecimiento.\n'
              '• Fotografía principal y galería (con autorización familiar).\n'
              '• Información del funeral (fecha, lugar, tanatorio).\n'
              '• Esquelas redactadas por la familia o el tanatorio.\n\n'
              'Queda expresamente prohibida la publicación de:\n\n'
              '• Causa del fallecimiento sin autorización explícita.\n'
              '• Información sobre el patrimonio o herencia.\n'
              '• Datos de menores de edad.\n'
              '• Información sensible (salud, religión, orientación sexual) sin consentimiento.',
        ),
        const _LegalSection(
          titulo: '4. Proceso de moderación',
          contenido:
              'Toda publicación en IN MEMORIAM pasa por el siguiente proceso:\n\n'
              '1. Envío de la publicación por parte del usuario o tanatorio.\n'
              '2. Revisión automática de contenido mediante filtros.\n'
              '3. Revisión manual por el equipo de moderación.\n'
              '4. Aprobación o rechazo con notificación al publicador.\n\n'
              'El plazo estimado de revisión es de 2 a 12 horas en días laborables.',
        ),
        const _LegalSection(
          titulo: '5. Derecho de retirada',
          contenido:
              'Los familiares directos del fallecido tienen derecho a solicitar la retirada de cualquier publicación que consideren atentatoria contra la dignidad del fallecido o que vulnere su intimidad.\n\n'
              'Para ello deben contactar con nosotros en privacidad@inmemoriam.es, identificándose como familiar directo y aportando documentación que acredite dicha relación.',
        ),
        const _LegalSection(
          titulo: '6. Tanatorios y funerarias',
          contenido:
              'Las entidades que deseen operar como tanatorio o funeraria verificada en IN MEMORIAM deben:\n\n'
              '• Registrarse como cuenta de entidad y aportar documentación de identificación.\n'
              '• Acreditar autorización de la familia para cada publicación.\n'
              '• Cumplir el código ético de publicación de IN MEMORIAM.\n'
              '• Someterse a las auditorías periódicas de cumplimiento.',
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ── Widget compartido de sección ────────────────────────────────────
class _LegalSection extends StatelessWidget {
  final String titulo;
  final String contenido;

  const _LegalSection({required this.titulo, required this.contenido});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          Text(
            contenido,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
          ),
        ],
      ),
    );
  }
}
