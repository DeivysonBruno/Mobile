import 'package:flutter/material.dart';
import 'package:gerenciador_loja/widgets/add_dialog.dart';

class ProductsSizes extends FormField<List>{

  ProductsSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator
}): super(
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (state){
      return SizedBox(
        height: 34,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
          mainAxisSpacing: 8,
            childAspectRatio: 0.5
          ),
          padding: EdgeInsets.symmetric(vertical: 4),
          scrollDirection: Axis.horizontal,
          children: state.value.map((s){

            return GestureDetector(

              onLongPress: (){
                state.didChange(state.value..remove(s));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.pinkAccent, width: 3)
                ),
                alignment: Alignment.center,
                child: Text(s,style: TextStyle(color: Colors.white),),
              ),
            );
          }).toList()..add(
              GestureDetector(
               onTap: ()async {
                 String size = await showDialog(context: context, builder: (context)=> AddSizeDialog());
                 if(size != null){
                   state.didChange(state.value..add(size));
                 }

               },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color:state.hasError? Colors.red: Colors.pinkAccent, width: 3)
                  ),
                  alignment: Alignment.center,
                  child: Text("+",style: TextStyle(color: Colors.white),),
                ),
              )

          ),
        ),
      );
  }
  );
}