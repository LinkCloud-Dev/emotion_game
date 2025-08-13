import 'package:flutter/material.dart';
import '../model/inventory.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({super.key});

  @override
  State<InventoryPanel> createState() => InventoryPanelState();
}

class InventoryPanelState extends State<InventoryPanel> {
  List<InventoryItem> _inventory = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  @override
  void didUpdateWidget(InventoryPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reload inventory if necessary - removed automatic reload to prevent flashing
  }

  Future<void> _loadInventory() async {
    final inventory = await InventoryService.getInventory();
    if (mounted) {
      setState(() {
        _inventory = inventory;
      });
    }
  }

  // Public method to refresh inventory from external calls
  void refreshInventory() {
    _loadInventory();
  }

  void _useHelper() async {
    // Remove helper from inventory after use
    await InventoryService.removeItem('helper');
    await _loadInventory();

    // Show usage message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Helper used! All obstacles cleared!',
            style: TextStyle(
              fontFamily: 'ICELAND',
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width *
          0.45, // Even narrower - 45% of screen width
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black
            .withOpacity(0.4), // Less dark - reduced opacity from 0.7 to 0.4
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(
              fontFamily: 'ICELAND',
              fontSize: 24, // Larger text
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _inventory.isEmpty
                ? const Center(
                    child: Text(
                      'No items',
                      style: TextStyle(
                        fontFamily: 'ICELAND',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: _inventory.map((item) {
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12, bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (item.id == 'helper') {
                                _showHelperDialog();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Item image
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.asset(
                                      item.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.help,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Item name
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontFamily: 'ICELAND',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Item quantity
                                Text(
                                  'X${item.quantity}',
                                  style: TextStyle(
                                    fontFamily: 'ICELAND',
                                    fontSize: 12,
                                    color: Colors.yellow[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showHelperDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF13102F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Helper',
            style: TextStyle(
              fontFamily: 'ICELAND',
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'It can get rid of all your obstacles!\n\nDo you want to use it now?',
            style: TextStyle(
              fontFamily: 'ICELAND',
              fontSize: 20,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'ICELAND',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _useHelper();
              },
              child: const Text(
                'Use',
                style: TextStyle(
                  fontFamily: 'ICELAND',
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
