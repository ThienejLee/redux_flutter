import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// One simple action: Increment
enum Actions{ Increment }


// The reducer: get latest data and increase when receive action Increment
int counterReducer(int state, dynamic action){
  if( action == Actions.Increment){
    return state +1;
  }
  return state;
}

void main(){
  final store = new Store<int>(counterReducer, initialState: 0);

  runApp(new FlutterReduxApp(
    title: 'Flutter Redux Demo',
    store: store,
  ));

}

class FlutterReduxApp extends StatelessWidget {

  final Store<int> store;
  final String title;

  FlutterReduxApp({Key key, this.store, this.title}): super(key: key);



  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        theme: ThemeData.dark(),
        title: title,
        home: new Scaffold(
          appBar: AppBar(title: new Text(title),),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Text("You have pushed the button this many times:"),
                //Connect the Store to a Text Widget that renders the curret count.
                // We will wrap the Text Widget in a `StoreConnector` Widget. The 
                // `StoreConnector` ancestor, convert it into a String of the 
                // latest count, and pass that String to the `builder` funtions
                // as the `count`

                // Every time the button is tapped, an action is dispatched and
                // run through the reducer. After the reducer updates the state,
                // the Widget will be automatically rebuilt with the latest 
                // count. No need to manually manage subscriptions or Streams~!
                new StoreConnector<int, String>(
                  converter: (store) => store.state.toString(),
                  builder: (context, count){
                    return new Text(
                      count,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                )
              ],
            ),
          ),
          
          // Connect the Store to a FloatingActionButton. In this case, we'll 
          // use the Store to build a callback that with dispatch an Increment
          // Action.

          // Then, we'll pass this callback to the button's `onPressed` handler.
          floatingActionButton: new StoreConnector<int, VoidCallback>(
            converter: (store){
              // Return a `VoidCallBack`, which is a fancy name for a funtion 
              // with no parameters. It only dispatches an Increment action.
              return () => store.dispatch(Actions.Increment);
            },
            builder: (context, callback){
              return new FloatingActionButton(
                onPressed: callback,
                tooltip: 'Increment',
                child: new Icon(Icons.add),
                );
            },
            ),
        ),

      ),
    );
  }
}