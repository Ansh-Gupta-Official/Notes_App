import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:untitled1/boxes/boxes.dart';
import 'package:untitled1/models/notes.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final titleController =TextEditingController();
  final descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('NOTES APP'),
      ),
      body: ValueListenableBuilder<Box<Notes>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_){
          var data=box.values.toList().cast<Notes>();
          return ListView.builder(
            itemCount: box.length,
          itemBuilder: (context,index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(data[index].title.toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            _editMyDialog(data[index],data[index].title.toString(), data[index].description.toString());
                          },
                            child: Icon(Icons.edit)),
                        SizedBox(width: 15,),
                        InkWell(
                          onTap: (){
                              delete(data[index]);
                          },
                            child: Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),

                    Text(data[index].description.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),)
                  ],
                ),
              ),
            );
          });
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDialog();

        },
        child: Icon(Icons.add),
      ),
    );
  }
void delete(Notes notes)async{
    await notes.delete();
}
  Future<void> _editMyDialog(Notes notes, String title,String description){
    titleController.text=title;
    descriptionController.text=description;
    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description ',
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()async{
                  notes.title=titleController.text.toString();
                  notes.description=descriptionController.text.toString();
                  await notes.save();
                  Navigator.pop(context);
                },
                child: Text('Edit'),
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              )
            ],
          );
        });
  }
  Future<void> _showMyDialog(){
    return showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Text('Add Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter title ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Description ',
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                final data=Notes(title:titleController.text,
                description: descriptionController.text);
                final box=Boxes.getData();
                box.add(data);
                titleController.clear();
                descriptionController.clear();


                Navigator.pop(context);
              },
              child: Text('Add'),
          ),
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Cancel')
          )
        ],
      );
        });
  }
}
