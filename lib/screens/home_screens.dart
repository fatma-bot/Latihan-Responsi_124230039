import 'package:flutter/material.dart';
import 'package:latres/screens/detail_screens.dart';
import 'package:latres/services/amiibo_services.dart';
import 'package:latres/services/favorite_services.dart';
import 'package:latres/models/amiibo_model.dart'; // Pastikan import model

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final AmiiboService amiiboService = AmiiboService();
  final FavoriteService favService = FavoriteService();  

  Set<String> favoriteIds = {}; 

  @override
  void initState() {
    super.initState();
    _loadFavorites(); 
  }

  void _loadFavorites() async {
    final favorites = await favService.getFavorites();
    setState(() {
      favoriteIds = favorites.map((e) => e.tail ?? '').toSet();
    });
  }

  void _toggleFavorite(AmiiboModel amiibo) async {
    final String id = amiibo.tail ?? '';
    
    if (favoriteIds.contains(id)) {
      // Kalau sudah ada, hapus
      await favService.removeFavorite(id);
      setState(() {
        favoriteIds.remove(id);
      });
    } else {
      await favService.addFavorite(amiibo);
      setState(() {
        favoriteIds.add(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nintendo Amiibo List")),
      body: FutureBuilder<List<AmiiboModel>>(
        future: amiiboService.fetchAmiiboData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error cik"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Kosong cik"));
          }

          final amiiboList = snapshot.data!;
          return ListView.builder(
            itemCount: amiiboList.length,
            itemBuilder: (context, index) {
              final amiibo = amiiboList[index];
              return _amiiboList(amiibo);
            },
          );
        },
      ),
    );
  }

  Widget _amiiboList(AmiiboModel amiibo) {
    bool isFavorited = favoriteIds.contains(amiibo.tail);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              amiibo.image ?? '',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              errorBuilder: (_,__,___) => const Icon(Icons.error),
            ),
          ),
          title: Text(
            amiibo.character ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Game: ${amiibo.gameSeries}"),
          
          trailing: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              _toggleFavorite(amiibo);
              
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorited 
                    ? "Dihapus dari Favorite" 
                    : "Ditambahkan ke Favorite"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreens(amiibo: amiibo),
              ),
            );
            _loadFavorites();
          },
        ),
      ),
    );
  }
}