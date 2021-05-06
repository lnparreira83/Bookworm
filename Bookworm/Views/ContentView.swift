//
//  ContentView.swift
//  Bookworm
//
//  Created by Lucas Parreira on 18/04/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity:Book.entity(),sortDescriptors:[NSSortDescriptor(keyPath: \Book.title, ascending: true)]) var books:FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(books, id:\.self){book in
                    NavigationLink(destination:DetailView(book: book)){
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment:.leading){
                            
                            Text(book.title ?? "Unknow title")
                                .font(.headline).foregroundColor(book.rating == 1 ? .red : .black)
                            Text(book.author ?? "Unknow author")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }.onDelete(perform:deleteBooks)
            }
                .navigationBarTitle("Bookworms")
            .navigationBarItems(leading:EditButton(),trailing: Button(action:{
                    self.showingAddScreen.toggle()
                }){
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen){
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
            
        }
        
    }
    
    // MARK :- Metodos
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]

            // delete it from the context
            moc.delete(book)
        }

        // save the context
        try? moc.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
