import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

import '../providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  void _updateImage() {
    if(isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if(product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') 
        || url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return isValidProtocol && (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if(!isValid) {
      return;
    }

    _form.currentState.save();

    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'], 
      description: _formData['description'], 
      price: _formData['price'], 
      imageUrl: _formData['imageUrl']
    );

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<Products>(context, listen: false);
    
    try {
      if(_formData['id'] == null) {
        await provider.addProduct(newProduct);
      } else {
        await provider.updateProduct(newProduct);
      }
      Navigator.of(context).pop();
    } catch(error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro inesperado, tente depois.'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text('Fechar')
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: () {
              _saveForm();
            }
          ),
        ],
      ),
      body: _isLoading ? 
        Center(
          child: CircularProgressIndicator(),
        ) : 
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _formData['title'],
                  decoration: InputDecoration(labelText: 'Título'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => _formData['title'] = value,
                  validator: (value) {
                    if(value.trim().isEmpty) {
                      return 'Informe um título válido';
                    }

                    if(value.trim().length < 3) {
                      return 'Informe um título com no mínimo 3 letras';
                    }
                      
                    return null;  
                  },
                ),
                TextFormField(
                  initialValue: _formData['price'].toString(),
                  decoration: InputDecoration(labelText: 'Preço'),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _formData['price'] = double.parse(value),
                  validator: (value) {
                    bool empty = value.trim().isEmpty;
                    bool invalid = double.tryParse(value) == null || double.tryParse(value) <= 0;

                    if(empty || invalid) {
                      return 'Informe um preço válido';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData['description'],
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) => _formData['description'] = value,
                  validator: (value) {
                    if(value.trim().isEmpty) {
                      return 'Informe uma descrição válida';
                    }

                    if(value.trim().length < 7) {
                      return 'Informe um título com no mínimo 7 letras';
                    }
                      
                    return null;  
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'URL da imagem'),
                        initialValue: 'https://pcpraha.cz/wp-content/uploads/2019/11/konfigurator-herni-pc-designova-volba-2020-amd-nvidia-intel-1.jpg',
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageFocusNode,
                      // controller: _imageUrlController,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) => _formData['imageUrl'] = value,
                        validator: (value) {
                          bool empty = value.trim().isEmpty;                      
                          if(empty || (!isValidImageUrl(value))) 
                            return 'Informe uma URL válida';
                          
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 8, left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        )
                      ),
                      alignment: Alignment.center,
                      child: _imageUrlController.text.isEmpty 
                        ? Text('Informe a URL')
                        : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}