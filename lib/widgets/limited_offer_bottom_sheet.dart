import 'package:flutter/material.dart';
import 'custom_button.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D1B20),
            Color(0xFF1A0E13),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Bonus Features
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Alacağınız Bonuslar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBonusItem(
                      number: '4',
                      title: 'Premium\nHesap',
                    ),
                    _buildBonusItem(
                      number: '1',
                      title: 'Daha\nFazla Eşleşme',
                    ),
                    _buildBonusItem(
                      number: '2',
                      title: 'Öne\nÇıkarma',
                    ),
                    _buildBonusItem(
                      number: '3',
                      title: 'Daha\nFazla Beğeni',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Package Selection
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Kilidi açmak için bir jeton paketi seçin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Packages
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 25),
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: 200,
                    currentPrice: 330,
                    jetonCount: '330',
                    discount: '+10%',
                    price: '₺99,99',
                    isPopular: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: 2000,
                    currentPrice: 3375,
                    jetonCount: '3.375',
                    discount: '+70%',
                    price: '₺799,99',
                    isPopular: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: 1000,
                    currentPrice: 1350,
                    jetonCount: '1.350',
                    discount: '+35%',
                    price: '₺399,99',
                    isPopular: false,
                  ),
                ),
              ],
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Tüm Jetonları Gör',
                fontSize: 16,
                useTranslation: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusItem({
    required String number,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF8B2635).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/${number}.png',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard({
    required int originalPrice,
    required int currentPrice,
    required String jetonCount,
    required String discount,
    required String price,
    required bool isPopular,
  }) {
    // Renk tanımları
    final cardColors = isPopular
        ? [
            const Color(0xFF7C3AED),
            const Color(0xFF8B2635), // Mordan kırmızıya gradient
          ]
        : [
            const Color(0xFF8B2635),
            const Color(0xFF5B1A1A),
          ];

    final badgeColor = isPopular
        ? const Color(0xFF7C3AED) // Mor
        : const Color(0xFF8B2635); // Kırmızı

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Container
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: cardColors,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12), // Discount badge için boşluk

                // Original Price (crossed out)
                Text(
                  originalPrice.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

                const SizedBox(height: 4),

                // Current Jeton Count
                Text(
                  jetonCount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'Jeton',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 16),

                // Price
                Text(
                  price,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'Başına haftalık',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Discount Badge - Üstten taşan, konteyner rengiyle aynı
        Positioned(
          top: -20,
          left: 0,
          right: 25,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                discount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
