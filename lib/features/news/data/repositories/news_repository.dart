import '../../../../config/app_config.dart';
import '../models/news_model.dart';

/// Repositorio desacoplado para Novedades.
///
/// Preparado para consumir una API REST conectando la URL desde `AppConfig.newsApiUrl`.
class NewsRepository {
  Future<List<NewsModel>> getNews() async {
    if (AppConfig.newsApiUrl.isNotEmpty) {
      // TODO: Implementar consumo HTTP API de Novedades
    }

    // Datos simulados (Mock) para el desarrollo inicial
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const NewsModel(
        id: '1',
        title: 'Nueva Credencial Digital de Afiliados',
        date: '20 Julio 2026',
        description:
            'Le damos la bienvenida a nuestra nueva plataforma digital. Ahora puede llevar su credencial en su teléfono móvil y presentarla en cualquier centro prestador.',
      ),
      const NewsModel(
        id: '2',
        title: 'Campaña de Vacunación y Prevención',
        date: '15 Julio 2026',
        description:
            'Recuerde que ya se encuentra disponible la campaña de vacunación antigripal anual en todas las delegaciones de la obra social.',
      ),
      const NewsModel(
        id: '3',
        title: 'Horarios de Atención Telefónica',
        date: '01 Julio 2026',
        description:
            'Le recordamos a nuestros afiliados que la atención telefónica opera de Lunes a Viernes de 08:00 a 20:00 hs.',
      ),
    ];
  }
}
