import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/provincias_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';

class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  late FiltroBusqueda _filtro;

  // Controles locales
  String? _provincia;
  String? _localidad;
  RangeValues _rangoEdad = const RangeValues(0, 100);
  DateTime? _fechaDesde;
  DateTime? _fechaHasta;

  static const _provincias = ProvinciasData.todas;

  static const Map<String, List<String>> _localidadesPorProvincia = {
    'Madrid': ['Madrid', 'Alcalá de Henares', 'Leganés', 'Getafe', 'Móstoles'],
    'Barcelona': ['Barcelona', "L'Hospitalet", 'Badalona', 'Terrassa', 'Sabadell'],
    'Sevilla': ['Sevilla', 'Dos Hermanas', 'Alcalá de Guadaíra', 'Utrera'],
    'Valencia': ['Valencia', 'Gandia', 'Torrent', 'Sagunto', 'Paterna'],
    'Zaragoza': ['Zaragoza', 'Calatayud', 'Ejea de los Caballeros', 'Tarazona'],
    'Málaga': ['Málaga', 'Marbella', 'Vélez-Málaga', 'Torremolinos', 'Fuengirola'],
    'Alicante': ['Alicante', 'Elche', 'Torrevieja', 'Benidorm', 'Orihuela'],
    'Murcia': ['Murcia', 'Cartagena', 'Lorca', 'Molina de Segura', 'Alcantarilla'],
    'Córdoba': ['Córdoba', 'Lucena', 'Montilla', 'Puente Genil', 'Priego de Córdoba'],
    'Valladolid': ['Valladolid', 'Medina del Campo', 'Laguna de Duero', 'Arroyo de la Encomienda'],
    'Granada': ['Granada', 'Motril', 'Almuñécar', 'Loja', 'Guadix'],
    'Cádiz': ['Cádiz', 'Jerez de la Frontera', 'Algeciras', 'San Fernando', 'El Puerto de Santa María'],
    'Huelva': ['Huelva', 'Lepe', 'Almonte', 'Moguer', 'Ayamonte'],
    'Burgos': ['Burgos', 'Aranda de Duero', 'Miranda de Ebro'],
    'Toledo': ['Toledo', 'Talavera de la Reina', 'Illescas', 'Torrijos'],
    'La Coruña': ['A Coruña', 'Santiago de Compostela', 'Ferrol', 'Narón'],
    'Cantabria': ['Santander', 'Torrelavega', 'Castro-Urdiales', 'Laredo'],
    'Navarra': ['Pamplona', 'Tudela', 'Barañáin', 'Burlada'],
    'Asturias': ['Oviedo', 'Gijón', 'Avilés', 'Mieres'],
    'La Rioja': ['Logroño', 'Calahorra', 'Arnedo', 'Nájera'],
    'Las Palmas': ['Las Palmas de Gran Canaria', 'Telde', 'Arucas', 'Arrecife'],
    'Santa Cruz de Tenerife': ['Santa Cruz de Tenerife', 'San Cristóbal de La Laguna', 'Arona', 'Adeje'],
    'Illes Balears': ['Palma', 'Ibiza', 'Manacor', 'Calvià'],
    'Vizcaya': ['Bilbao', 'Barakaldo', 'Getxo', 'Basauri'],
    'Guipúzcoa': ['Donostia-San Sebastián', 'Irun', 'Errenteria', 'Zarautz'],
    'Álava': ['Vitoria-Gasteiz', 'Llodio', 'Amurrio'],
  };

  @override
  void initState() {
    super.initState();
    _filtro = context.read<AppState>().filtro;
    _provincia = _filtro.provincia;
    _localidad = _filtro.localidad;
    _rangoEdad = RangeValues(
      (_filtro.edadMin ?? 0).toDouble(),
      (_filtro.edadMax ?? 100).toDouble(),
    );
    _fechaDesde = _filtro.fechaDesde;
    _fechaHasta = _filtro.fechaHasta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Filtrar fallecidos'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _limpiarTodo,
            child: Text(
              'Limpiar',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.sm),

          // ── Ubicación ───────────────────────────────────────
          _buildSeccion(
            titulo: 'Ubicación',
            icon: Icons.location_on_outlined,
            child: Column(
              children: [
                // Provincia
                DropdownButtonFormField<String>(
                  value: _provincia,
                  decoration: const InputDecoration(
                    labelText: 'Provincia',
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas las provincias')),
                    ..._provincias.map((p) => DropdownMenuItem(value: p, child: Text(p))),
                  ],
                  onChanged: (v) => setState(() {
                    _provincia = v;
                    _localidad = null; // resetea localidad al cambiar provincia
                  }),
                  style: AppTextStyles.bodyMedium,
                  isExpanded: true,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Localidad (solo si hay provincia con datos)
                DropdownButtonFormField<String>(
                  value: _localidad,
                  decoration: const InputDecoration(
                    labelText: 'Localidad',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas las localidades')),
                    ...(_provincia != null && _localidadesPorProvincia.containsKey(_provincia)
                            ? _localidadesPorProvincia[_provincia]!
                            : <String>[])
                        .map((l) => DropdownMenuItem(value: l, child: Text(l))),
                  ],
                  onChanged: (v) => setState(() => _localidad = v),
                  style: AppTextStyles.bodyMedium,
                  isExpanded: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Rango de edad ───────────────────────────────────
          _buildSeccion(
            titulo: 'Rango de edad',
            icon: Icons.person_outline,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ChipEdad(valor: '${_rangoEdad.start.round()} años'),
                    Text('—', style: AppTextStyles.bodySmall),
                    _ChipEdad(valor: '${_rangoEdad.end.round()} años'),
                  ],
                ),
                RangeSlider(
                  values: _rangoEdad,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: AppColors.gold,
                  inactiveColor: AppColors.border,
                  labels: RangeLabels(
                    '${_rangoEdad.start.round()}',
                    '${_rangoEdad.end.round()}',
                  ),
                  onChanged: (v) => setState(() => _rangoEdad = v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 años', style: AppTextStyles.labelSmall),
                    Text('100 años', style: AppTextStyles.labelSmall),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Rango de fechas ─────────────────────────────────
          _buildSeccion(
            titulo: 'Fecha de fallecimiento',
            icon: Icons.calendar_today_outlined,
            child: Row(
              children: [
                Expanded(
                  child: _DatePickerField(
                    label: 'Desde',
                    fecha: _fechaDesde,
                    ultimaFecha: _fechaHasta,
                    onFechaSeleccionada: (f) => setState(() => _fechaDesde = f),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DatePickerField(
                    label: 'Hasta',
                    fecha: _fechaHasta,
                    primeraFecha: _fechaDesde,
                    onFechaSeleccionada: (f) => setState(() => _fechaHasta = f),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Botón aplicar ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Aplicar filtros'),
              onPressed: _aplicar,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(titulo.toUpperCase(), style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }

  void _limpiarTodo() {
    setState(() {
      _provincia = null;
      _localidad = null;
      _rangoEdad = const RangeValues(0, 100);
      _fechaDesde = null;
      _fechaHasta = null;
    });
  }

  void _aplicar() {
    final edadMinActiva = _rangoEdad.start.round() > 0;
    final edadMaxActiva = _rangoEdad.end.round() < 100;

    final nuevoBusqueda = FiltroBusqueda(
      provincia: _provincia,
      localidad: _localidad,
      edadMin: edadMinActiva ? _rangoEdad.start.round() : null,
      edadMax: edadMaxActiva ? _rangoEdad.end.round() : null,
      fechaDesde: _fechaDesde,
      fechaHasta: _fechaHasta,
      textoBusqueda: context.read<AppState>().filtro.textoBusqueda,
    );

    context.read<AppState>().actualizarFiltro(nuevoBusqueda);
    context.pop();
  }
}

class _ChipEdad extends StatelessWidget {
  final String valor;
  const _ChipEdad({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold),
      ),
      child: Text(valor, style: AppTextStyles.labelMedium.copyWith(color: AppColors.goldDark)),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? fecha;
  final DateTime? primeraFecha;
  final DateTime? ultimaFecha;
  final ValueChanged<DateTime?> onFechaSeleccionada;

  const _DatePickerField({
    required this.label,
    required this.fecha,
    this.primeraFecha,
    this.ultimaFecha,
    required this.onFechaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _seleccionar(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(
            color: fecha != null ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: fecha != null ? AppColors.gold : AppColors.textHint,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                fecha != null
                    ? '${fecha!.day}/${fecha!.month}/${fecha!.year}'
                    : label,
                style: fecha != null
                    ? AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)
                    : AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (fecha != null)
              GestureDetector(
                onTap: () => onFechaSeleccionada(null),
                child: const Icon(Icons.clear, size: 14, color: AppColors.textHint),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionar(BuildContext context) async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fecha ?? ahora,
      firstDate: primeraFecha ?? DateTime(2000),
      lastDate: ultimaFecha ?? ahora,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (picked != null) onFechaSeleccionada(picked);
  }
}
