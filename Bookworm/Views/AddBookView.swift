//
//  AddBookView.swift
//  Bookworm
//
//  Created by Lucas Parreira on 18/04/21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Name of book : ",text:$title)
                    TextField("Author's name : ", text:$author)
                    
                    Picker("Genre : ",selection:$genre){
                        ForEach(genres, id: \.self){
                            Text($0)
                        }
                    }
                }
                    
                    Section{
                        RatingView(rating: $rating)
                        TextField("Write a review : ",text:$review)
                        
                    }
                    
                    Section{
                        Button("Save"){
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.genre = self.genre
                            if(newBook.genre?.isEmpty == true){
                                newBook.genre = "Fantasy"
                            }
                            newBook.rating = Int16(self.rating)
                            newBook.review = self.review
                            
                            try? self.moc.save()
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                }
            }
        }
    
    }

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
