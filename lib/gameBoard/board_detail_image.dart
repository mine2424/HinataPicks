import '../importer.dart';

// ignore: must_be_immutable
class BoardDetailsImage extends StatelessWidget {
  var image;
  BoardDetailsImage({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                mini: true,
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ),
        Hero(
          tag: 'imageTag',
          child: Center(
            child: SizedBox(
              child: Image.network(image),
            ),
          ),
        )
      ],
    );
  }
}
