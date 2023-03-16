import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vault_pass/application/record_form/record_bloc.dart';
import 'package:vault_pass/application/record_removal/record_removal_bloc.dart';
import 'package:vault_pass/domain/core/export_extension.dart';
import 'package:vault_pass/presentation/router/app_router.gr.dart';
import 'package:vault_pass/presentation/utils/palette.dart';

import '../../../../domain/microtypes/microtypes.dart';
import '../../../../domain/model/record.dart';
import '../../../../injection.dart';
import '../../../core/device_size.dart';
import '../../../utils/butter.dart';
import '../../../utils/css.dart';
import '../../../utils/style.dart';

class AccountView extends StatelessWidget {
  final Record record;

  const AccountView({required this.record, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// INIT THE RECORD TO THE BLOC
    return WillPopScope(
      //this makes the device button work to go back
      onWillPop: () {
        context.navigateBack();
        return Future.value(false);
      },
      child: BlocBuilder<RecordBloc, RecordState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Palette.blackFull,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! RECORD TYPE
                          _RecordTypeWidget(value: state.record.type.value.toLowerCase()),
                          const Divider(height: 10, thickness: 1, color: Colors.white),
                          const SizedBox(height: 10),

                        //! RECORD NAME
                        ViewCardWidget(
                            textWidget: {"Record name": state.record.recordName.get()},
                            cardHeight: 12),

                        //! Title
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 10, 2),
                          child: Text("Credentials", style: bodyText(12, Palette.greySpanish)),
                        ),

                        //! RECORD LOGIN AND PASSWORD
                        ViewCardWidget(textWidget: {
                          "Login": state.record.loginRecord.get(),
                          "Password": state.record.passwordRecord.get()
                        }, cardHeight: 24),

                        //! URL
                        ViewCardWidget(
                            textWidget: {"Url": state.record.url.get()}, cardHeight: 12),

                        //! DESCRIPTION
                        ViewCardWidget(
                            textWidget: {"Description": state.record.description.get()},
                            cardHeight: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: _SpeedDialFabWidget(recordId: state.record.id),
        );
      },
    ),
    );
  }
}

class _RecordTypeWidget extends StatelessWidget {
  final String value;

  const _RecordTypeWidget({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$value details',
        style: headerText25_white,
      ),
    );
  }
}

class ViewCardWidget extends StatelessWidget {
  final Map<String, String> textWidget;
  final int cardHeight;
  final Color? cardColor;

  ViewCardWidget({required this.textWidget, required this.cardHeight, this.cardColor, super.key}) {
    if (textWidget.size > 1) {
      checkHeight(cardHeight, 25);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = <Widget>[];
    textWidget.forEach((k, v) {
      textWidgets.add(Text(k, style: bodyText(12, Palette.greySpanish)));
      textWidgets.add(Text(v, style: bodyText(15, Palette.whiteSnow)));
      if (textWidget.size > 1) {
        textWidgets.add(const SizedBox(
          height: 25,
        ));
      }
    });
    return SizedBox(
      width: double.infinity,
      height: heightPercentOf(cardHeight.toDouble(), context),
      child: Card(
        color: cardColor ?? Palette.blackCard,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusCircular,
        ),
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 10, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textWidgets,
          ),
        ),
      ),
    );
  }
}

class _SpeedDialFabWidget extends StatelessWidget {

  final UniqueId recordId;

  const _SpeedDialFabWidget({Key? key, required this.recordId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.settings,
      activeIcon: Icons.close,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular)),
      childPadding: const EdgeInsets.all(5),
      buttonSize: Size.fromRadius(30),
      childrenButtonSize: Size.fromRadius(30),
      direction: SpeedDialDirection.left,
      overlayOpacity: 0,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.refresh_sharp),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular)),
          //label: 'Back',
          visible: true,
          onTap: () => context.navigateBack(),
          onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.edit),
          backgroundColor: Palette.whiteSnow,
          foregroundColor: Palette.blackCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular)),
          //label: 'Edit',
          onTap: () => context.pushTo(AccountEditView()),
          //onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
            child: const Icon(Icons.delete),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radiusCircular)),
            //label: 'Delete',
            onTap: () {
              //context.read<RecordBloc>().add(RecordEvent.initialized(Option.of(record)));
              getIt<RecordRemovalBloc>().add(RecordRemovalEvent.remove(recordId));
              //context.bloc<BlocRemoval>();
              context.teleportTo(HomeView());
            }),
      ],
    );
  }
}
