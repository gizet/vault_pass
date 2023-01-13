import 'package:flutter/material.dart';
import 'package:vault_pass/ui/widgets/animations_widget.dart';
import 'package:vault_pass/ui/widgets/tab_widget.dart';
import 'package:vault_pass/util/constants/palette.dart';

import '../../util/constants/css.dart';
import '../../util/constants/style.dart';
import '../../util/device_size.dart';
import '../router/app_router.dart';
import '../router/teleport.dart';
import '../widgets/avatar_widget.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Transform.scale(
          scaleX: -1,
          child: IconButton(
              tooltip: "Logout",
              onPressed: () => Teleport.to(context, RouteName.LOGIN_VIEW),
              icon: const Icon(
                Icons.login_sharp,
                color: whiteFull,
              )),
        ),
        //TODO: Make this dynamic of showing the initials
        title: const Center(child: Text("Vault Pass", style: bodyText15_white_bold)),
        actions: const [Avatar()],
        toolbarHeight: heightPercentOf(8, context),
      ),
      body: TabWidget(),
      floatingActionButton: FabWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
          ],
        ),
      ),
    );
  }
}

class FabWidget extends StatelessWidget {
  const FabWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotateWidget(
      degree: Degree.flat(),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular)),
        child: const Icon(Icons.add),
        //TODO: add functionality
        onPressed: () {},
      ),
    );
  }
}
