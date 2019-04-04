import 'package:flutter/material.dart';
import '../ui/widgets/card_front.dart';
import '../ui/widgets/my_appbar.dart';
import '../ui/app.dart';
import '../blocs/card_bloc.dart';
import '../blocs/bloc_provider.dart';

class CardWallet extends StatefulWidget {
  @override
  _CardWallet createState() => _CardWallet();
}

class _CardWallet extends State<CardWallet> with TickerProviderStateMixin {
  AnimationController rotateController;
  AnimationController opacityControler;
  Animation<double> animation;
  Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    final CardBloc bloc = BlocProvider.of<CardBloc>(context);
    rotateController = AnimationController(
        vsync: this, duration: new Duration(microseconds: 300));
    opacityControler =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));

    CurvedAnimation curvedAnimation = new CurvedAnimation(
        parent: opacityControler, curve: Curves.fastOutSlowIn);

    animation = Tween(begin: -2.0, end: -3.15).animate(rotateController);
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

    opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bloc.saveCard();
        Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
      }
    });

    rotateController.forward();
    opacityControler.forward();
  }

  @override
  void dispose() {
    rotateController.dispose();
    opacityControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Wallet',
        leadingIcon: Icons.arrow_back,
        context: context,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: AnimatedBuilder(
                animation: animation,
                child: Container(
                  width: _screenSize.width / 1.6,
                  height: _screenSize.height / 2.2,
                  child: CardFront(rotatedTurnsValue: -3),
                ),
                builder: (context, _widget) {
                  return Transform.rotate(
                    angle: animation.value,
                    child: _widget,
                  );
                },
              ),
            ),
            SizedBox(
              height: 150.0,
            ),
            CircularProgressIndicator(
              strokeWidth: 6.0,
              backgroundColor: Colors.lightBlue,
            ),
            SizedBox(
              height: 30.0,
            ),
            FadeTransition(
              opacity: opacityAnimation,
              child: Text('Card Added',
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
