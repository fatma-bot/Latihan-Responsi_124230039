import 'package:flutter/material.dart';
import 'package:latres/models/amiibo_model.dart';
import 'package:latres/screens/favorite_screens.dart';
import 'package:latres/services/favorite_services.dart';

class DetailScreens extends StatefulWidget {
  final AmiiboModel amiibo;
  const DetailScreens({super.key, required this.amiibo});

  @override
  State<DetailScreens> createState() => _DetailScreensState();
}

class _DetailScreensState extends State<DetailScreens> {
  final FavoriteService favoriteService = FavoriteService();

  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    bool status = await favoriteService.isFavorite(widget.amiibo.tail ?? '');
    setState(() {
      isFavorited = status;
    });
  }

  void _toggleFavorite() async {
    if (isFavorited) {
      await favoriteService.removeFavorite(widget.amiibo.tail ?? '');
    } else {
      await favoriteService.addFavorite(widget.amiibo);
    }
    setState(() {
      isFavorited = !isFavorited;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorited ? "Ditambahkan ke Favorite" : "Dihapus dari Favorite",
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("amiibos Detail"),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              _toggleFavorite();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.network(
                  widget.amiibo.image ?? '',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, StackTrace) => Container(
                    height: 250,
                    width: 250,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(widget.amiibo.character, style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),
            _buildInfoRow("Amiibo Series", widget.amiibo.amiiboSeries),
            _buildInfoRow("Character", widget.amiibo.character),
            _buildInfoRow("Game Series", widget.amiibo.gameSeries),
            _buildInfoRow("Type", widget.amiibo.type),
            _buildInfoRow("Head", widget.amiibo.head),
            _buildInfoRow("Tail", widget.amiibo.tail),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Release Date",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 15),
            _buildInfoRow("Australia", widget.amiibo.release.au ?? ""),
            _buildInfoRow("Europe", widget.amiibo.release.eu ?? ""),
            _buildInfoRow("Japan", widget.amiibo.release.jp ?? ""),
            _buildInfoRow("North America", widget.amiibo.release.na ?? ""),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
