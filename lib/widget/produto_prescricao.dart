import 'package:flutter/material.dart';
import 'package:lojagerencia/widget/add_prescricao.dart';

class ProdutoPrescricao extends FormField<List> 
{
  ProdutoPrescricao( 
    {
      BuildContext context,
      List initialValue,
      FormFieldSetter<List> onSaved,
      FormFieldValidator<List> validator
    }) : super( 
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
    builder : (state) 
    {
        return SizedBox(
          height: 50,
          child: GridView(
            padding: EdgeInsets.symmetric(vertical: 4),
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //Caso o valor da prescricao seja muito grande, mudar este  campoa aqui
            crossAxisCount: 1, 
            mainAxisSpacing: 13, 
            childAspectRatio: 0.3, 
            ),
            children: state.value.map(
                (s) 
                {
                  return GestureDetector(
                    onLongPress: () 
                    {
                      state.didChange(state.value..remove(s));
                    },
                    child: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 3
                      )
                      ),
                      alignment: Alignment.center,
                      child: Text( s, style: TextStyle(
                        color: Colors.white
                        )
                        ),
                      )
                      );
                }
            ).toList()..add(
              GestureDetector(
                onTap: () async 
                {
                  String prescricao = await showDialog(context: context, builder: (context)=> AddDialog());
                  if(prescricao != null) state.didChange(state.value..add(prescricao));
                },
                    child: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        color: state.hasError ? Colors.red :Colors.blueAccent,
                        width: 3
                      )
                      ),
                      alignment: Alignment.center,
                      child: Text( "+", style: TextStyle(
                        color: Colors.white
                        )
                        ),
                      )
                      )
            )
          ),
          );
    });
}