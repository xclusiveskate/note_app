import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/model/model.dart';

bool isSearching = false;
bool isEditing = false;
List<MyNote> notes = [];
List<MyNote> notesByCategory = [];
List<MyNote> searchNotes = [];
List<CategoryModel> categories = [];
bool isListView = false;
bool startSelecting = false;
List<MyNote> selectedNotes = [];
TextStyle title = GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.normal);
TextStyle content =
    GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.normal);
