import 'package:Robeats/device/device.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class LocalNetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: _createGridView(),
      ),
    );
  }

  GridView _createGridView() {
    List<Widget> widgets = [_NetworkGridTile(Device.LOCAL_DEVICE)]; //todo: load this from bloc.

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      children: widgets,
    );
  }
}

class _NetworkGridTile extends StatelessWidget {
  final Device _device;

  _NetworkGridTile(this._device);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      Expanded(
        flex: 6,
        child: LayoutBuilder(builder: (context, constraint) => Icon(Icons.devices)),
      ),
      Expanded(
        flex: 4,
        child: Text(
          _device.chosenIdentifier,
          textAlign: TextAlign.center,
        ),
      ),
    ];

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );

    return GridTile(child: Card(child: column));
  }
}
