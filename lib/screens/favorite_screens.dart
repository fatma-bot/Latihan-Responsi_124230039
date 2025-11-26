import 'package:flutter/material.dart';
import 'package:latres/models/amiibo_model.dart';
import 'package:latres/screens/detail_screens.dart';
import 'package:latres/services/favorite_services.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService favService = FavoriteService();
  late Future<List<AmiiboModel>> _favoriteFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _favoriteFuture = favService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: FutureBuilder<List<AmiiboModel>>(
        future: _favoriteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data favorite"));
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final amiibo = favorites[index];

              return Dismissible(
                // Key Wajib Unik (Pakai ID)
                key: Key(amiibo.tail ?? UniqueKey().toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                // LOGIKA HAPUS SAAT DI-SWIPE
                onDismissed: (direction) async {
                  // 1. Hapus dari SharedPreferences
                  await favService.removeFavorite(amiibo.tail ?? '');

                  // 2. Tampilkan SnackBar
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${amiibo.character} dihapus")),
                    );
                  }
                },

                // Tampilan Kartu
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        amiibo.image ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood),
                      ),
                    ),
                    title: Text(amiibo.character ?? "-"),
                    subtitle: Text(amiibo.amiiboSeries ?? "-"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailScreens(amiibo: amiibo);
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
