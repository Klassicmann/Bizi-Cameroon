import 'package:bizi/widgets/p_images.dart';
import 'package:bizi/widgets/p_videos.dart';
import 'package:bizi/widgets/profileProducts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageViewBuilder extends StatefulWidget {
  const PageViewBuilder({this.id});
  final String id;

  @override
  _PageViewBuilderState createState() => _PageViewBuilderState();
}

class _PageViewBuilderState extends State<PageViewBuilder> {
  PageController _pageController;
  int pageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

        // color: Colors.red,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 44,
              // color: Colors.black54,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  OnePage(
                    pageController: _pageController,
                    page: 0,
                    title: 'Catalogue',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OnePage(
                    pageController: _pageController,
                    page: 1,
                    title: 'Photos',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OnePage(
                    pageController: _pageController,
                    page: 2,
                    title: 'Videos',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OnePage(
                    pageController: _pageController,
                    page: 3,
                    title: 'Documents',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OnePage(
                    pageController: _pageController,
                    page: 4,
                    title: 'Notes',
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.1,
                  minHeight: 310),
              // height: 500,
              child: PageView(
                controller: _pageController,
                children: [Products(id: widget.id,), PImages(id: widget.id,), PVideos()],
              ),
            ),
          ],
        ));
  }
}

class OnePage extends StatelessWidget {
  const OnePage({
    Key key,
    @required PageController pageController,
    this.title,
    this.page,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (_pageController.hasClients) {
            _pageController.animateToPage(page,
                duration: Duration(microseconds: 1000), curve: Curves.linear);
          }
        },
        child: Container(
          height: 20,
          padding: EdgeInsets.only(top: 5, left: 10, right: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20)
              ),
          child: Text(
            title,
            
            style: GoogleFonts.k2d(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, ),
          ),
        ),
      ),
    );
  }
}
