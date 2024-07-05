import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../cubits/room_cubit.dart';
import '../../widgets/custom_sliver_app_bar_delegate.dart';
import '../../widgets/responsive_button.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _uploadButtonKey = GlobalKey();

  String _complexity = 'all';
  String _texture = 'all';
  Color? _selectedColor;

  final List<Color> _colorSet = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.grey,
    Colors.pink,
    const Color.fromARGB(255, 179, 146, 146),
    Colors.black,
  ];

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
    String colorParam = _selectedColor != null
        ? '#${_selectedColor!.value.toRadixString(16).substring(2)}'
        : 'all';
    BlocProvider.of<RoomCubit>(context)
        .fetchImages(_complexity, _texture, colorParam);
  }

  @override
  Widget build(BuildContext context) {
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
                    );
                  },
                  height: 100,
                  iconColor: Colors.white,
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.white,
                  ),
                  text: "Upload Your Room",
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
                            DropdownMenuItem(value: 'high', child: Text('High')),
                            DropdownMenuItem(value: 'all', child: Text('All')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _complexity = value!;
                              _fetchImages();
                            });
                          },
                          hint: const Text('complex'),
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
                                      children: _colorSet.map((color) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedColor = color;
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
                          child: Icon(Icons.color_lens),
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
                            state.images[index].imgurl,
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FloatingActionButton(
                shape: CircleBorder(eccentricity: 1),
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
