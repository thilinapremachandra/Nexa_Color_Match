import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../../cubits/room_cubit.dart';
import '../../../widgets/custom_sliver_app_bar_delegate.dart';
import '../../../widgets/responsive_button.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  String name = "defaultName";
  String email = "defaultEmail@example.com";

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _uploadButtonKey = GlobalKey();

  String _complexity = 'all';
  String _texture = 'all';
  Color? _selectedColor;

  final Map<Color?, String> _colorSet = {
    null: 'all', // All
    const Color.fromARGB(255, 255, 0, 0): 'red', // Red
    const Color.fromARGB(255, 0, 255, 0): 'green', // Green
    const Color.fromARGB(255, 0, 0, 255): 'blue', // Blue
    const Color.fromARGB(255, 255, 255, 0): 'yellow', // Yellow
    const Color.fromARGB(255, 255, 192, 203): 'pink', // Pink
    const Color.fromARGB(255, 128, 0, 128): 'purple', // Purple
    const Color.fromARGB(255, 255, 0, 255): 'magenta', // Magenta
    const Color.fromARGB(255, 128, 128, 128): 'grey', // Grey
    const Color.fromARGB(255, 255, 255, 255): 'white', // White
    const Color.fromARGB(255, 0, 0, 0): 'black', // Black
    const Color.fromARGB(255, 165, 42, 42): 'brown', // Brown
    const Color.fromARGB(255, 255, 165, 0): 'orange', // Orange
    const Color.fromARGB(255, 64, 224, 208): 'turquoise', // Turquoise
    const Color.fromARGB(255, 0, 128, 128): 'teal', // Teal
    const Color.fromARGB(255, 230, 230, 250): 'lavender', // Lavender
    const Color.fromARGB(255, 0, 0, 128): 'navy', // Navy
    const Color.fromARGB(255, 245, 245, 220): 'beige', // Beige
    const Color.fromARGB(255, 255, 127, 80): 'coral', // Coral
    const Color.fromARGB(255, 62, 180, 137): 'mint', // Mint
    const Color.fromARGB(255, 225, 229, 180): 'peach', // Peach
    const Color.fromARGB(255, 255, 215, 0): 'gold', // Gold
    const Color.fromARGB(255, 192, 192, 192): 'silver', // Silver
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkButtonVisibility();
    });
    _fetchImages();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _checkButtonVisibility();
  }

  void _checkButtonVisibility() {
    final renderBox =
        _uploadButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.of(context).size.height;

      if (position < screenHeight && position > 0) {
        BlocProvider.of<RoomCubit>(context).showFloatingButton(false);
      } else {
        BlocProvider.of<RoomCubit>(context).showFloatingButton(true);
      }
    }
  }

  void _fetchImages() {
    // String colorParam = _selectedColor != null
    //     ? '#${_selectedColor!.value.toRadixString(16).substring(2)}'
    //     : 'all';
    String colorParam =
        _selectedColor != null ? _colorSet[_selectedColor]! : 'all';

    BlocProvider.of<RoomCubit>(context)
        .fetchImages(_complexity, _texture, colorParam);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is not null, update name and email
    if (args != null) {
      name = args['name'] ?? "defaultName";
      email = args['email'] ?? "defaultEmail@example.com";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(
                expandedHeight: 190,
              ),
              pinned: true,
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(5.0),
                key: _uploadButtonKey,
                child: ResponsiveButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/panoramacapture',
                      arguments: {
                        'name': name,
                        'email': email,
                      },
                    );
                  },
                  height: 100,
                  iconColor: Colors.white,
                  icon: const Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.white,
                  ),
                  text: " $name",
                  textColor: Colors.white,
                  textSize: 30,
                  width: 120,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Complexity",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "Texture",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "Color",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: _complexity,
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Low')),
                            DropdownMenuItem(
                                value: 'high', child: Text('High')),
                            DropdownMenuItem(value: 'all', child: Text('All')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _complexity = value!;
                              _fetchImages();
                            });
                          },
                          hint: const Text('Complexity'),
                        ),
                        DropdownButton<String>(
                          value: _texture,
                          items: const [
                            DropdownMenuItem(value: 'yes', child: Text('Yes')),
                            DropdownMenuItem(value: 'no', child: Text('No')),
                            DropdownMenuItem(value: 'all', child: Text('All')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _texture = value!;
                              _fetchImages();
                            });
                          },
                          hint: const Text('Texture'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Select Color'),
                                  content: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: _colorSet.keys.map((color) {
                                        final bool isSelected =
                                            _selectedColor == color;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedColor =
                                                  isSelected ? null : color;
                                              Navigator.of(context).pop();
                                              _fetchImages();
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: color,
                                              border: Border.all(
                                                color: _selectedColor == color
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(Icons.color_lens),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return SliverToBoxAdapter(child: _buildShimmerPlaceholders());
                } else if (state.hasError) {
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('Failed to load images')));
                } else {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 4,
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            state.images[index].augmentedImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(2),
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          return Visibility(
            visible: state.showFloatingButton,
            child: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
                onPressed: () {},
                child: const Icon(
                  size: 30,
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerPlaceholders() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
          );
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
