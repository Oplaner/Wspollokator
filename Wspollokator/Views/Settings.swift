//
//  Settings.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 12/11/2021.
//

import SwiftUI

struct Settings: View {
    //@EnvironmentObject user
    //Zmienne dotyczące customowych alertów
    @State var isPasswordAlertPresented: Bool = false
    @State var isDescriptionAlertPresented: Bool = false
    //Zmienne do customowych alertów
    @State var oldPassword: String = ""
    @State var newPassword: String = ""
    @State var description: String = UserProfile_Previews.users[0].description
    //"Freezowanie" przycisków
    @State private var isPhotoButtonClickable: Bool = true
    @State private var isPasswordButtonClickable: Bool = true
    @State private var isDescriptionButtonClickable: Bool = true
    @State private var isLogOutButtonClickable: Bool = true
    //Alerty
    @State private var isPassPassedAlertPresented: Bool = false
    @State private var isPassFailedAlertPresented: Bool = false
    @State private var isLogOutAlertPresented: Bool = false
    //Liczba nideudanych prób wpisania hasła
    @State private var failedAttempts: Int = 0
    //Dla failedAttempts = 5
    @State private var isPassworButtonBlocked: Bool = false
    //testing password, temporary
    let password: String = "1234"
    var user : User
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            Avatar(image: user.avatarImage, size: 80)
                            Button {
                                if isPhotoButtonClickable{
                                    //Image Picker prawdopodobnie
                                    print("Zmienianie zdjęcia...")
                                }
                            } label: {
                                Text("Zmień zdjęcie")
                            }
                        }
                        Spacer()
                    }
                    Section {
                        HStack {
                            Text("Imię")
                            Spacer(minLength: 50)
                            Text(user.name)
                        }
                        HStack {
                            Text("Nazwisko")
                            Spacer(minLength: 50)
                            Text(user.surname)
                        }
                        HStack {
                            Text("Adres e-mail")
                            Spacer(minLength: 50)
                            Text("john.a....com ")
                        }
                        Button {
                            if isPasswordButtonClickable {
                                isPasswordAlertPresented = true
                                
                                isPhotoButtonClickable = false
                                isDescriptionButtonClickable = false
                                isLogOutButtonClickable = false
                            }
                        } label : {
                            HStack {
                                Text("Hasło:")
                                Spacer()
                                Image(systemName: "chevron.forward.circle")
                            }
                            .foregroundColor(.black)
                        }
                        Button {
                            if isDescriptionButtonClickable {
                                description = UserProfile_Previews.users[0].description
                                isDescriptionAlertPresented = true
                                
                                isPhotoButtonClickable = false
                                isPasswordButtonClickable = false
                                isLogOutButtonClickable = false
                            }
                        } label : {
                            HStack {
                                Text("Mój opis:")
                                Spacer()
                                Image(systemName: "chevron.forward.circle")
                            }
                            .foregroundColor(.black)
                        }
                    }
                    Section {
                            Button {
                                if isLogOutButtonClickable {
                                    isLogOutAlertPresented = true
                                }
                            } label: {
                                Text("WYLOGUJ SIĘ")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.red)
                            }
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Ustawienia")
                .navigationBarTitleDisplayMode(.inline)
                
                PasswordAlert(isShown: $isPasswordAlertPresented, oldPass: $oldPassword, newPass: $newPassword, onDone: {
                    if (oldPassword == self.password) {
                        //jeżeli zgadza się 'stare' plus 'nowe' spełnia krtyteria dla nowego hasła
                        //zmiana hasła na nowe....
                        isPasswordAlertPresented = false
                        isPhotoButtonClickable = true
                        isDescriptionButtonClickable = true
                        isLogOutButtonClickable = true
                        oldPassword = ""
                        isPassPassedAlertPresented = true
                    }
                    else {
                        isPasswordAlertPresented = true
                        failedAttempts += 1
                        if failedAttempts == 5 {
                            isPasswordAlertPresented = false
                            
                            isPhotoButtonClickable = true
                            isDescriptionButtonClickable = true
                            isLogOutButtonClickable = true
                            
                            oldPassword = ""
                            isPassFailedAlertPresented = true
                            failedAttempts = 0
                            //...
                            isPasswordButtonClickable = false
                            isPassworButtonBlocked = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                isPassworButtonBlocked = false
                                isPasswordButtonClickable = true
                            }
                            //...inform user about failed attempts, and that he will be able to try again in \(remained time)
                        }
                    }
                }) {
                    isPhotoButtonClickable = true
                    isDescriptionButtonClickable = true
                    isLogOutButtonClickable = true
                }
                DescriptionAlert(isShown: $isDescriptionAlertPresented, desc: $description, onDone: {
                    //user description = description, zmienna jest zbindowana i nie trzeba jej przesyłać dodatkowo
                    isDescriptionAlertPresented = false
                    
                    
                    if !isPassworButtonBlocked {
                        isPasswordButtonClickable = true
                    }
                    isPhotoButtonClickable = true
                    isLogOutButtonClickable = true
                }) {
                    isPhotoButtonClickable = true
                    if !isPassworButtonBlocked {
                        isPasswordButtonClickable = true
                    }
                    isLogOutButtonClickable = true
                }
            }
            .alert("Hasło zostało zmienione pomyślnie!", isPresented: $isPassPassedAlertPresented) {
                Button("OK", role: .cancel) {}
            }
            .alert("Zbyt dużo nieudanych prób. Proszę, spróbuj za 5 minut.", isPresented: $isPassFailedAlertPresented) {
                Button("OK", role: .cancel) {}
            }
            .alert("Czy na pewno chcesz się wylogować?", isPresented: $isLogOutAlertPresented) {
                HStack {
                    Button("Anuluj", role: .cancel) {}
                    Button {
                        //...wyloguj, nawiguj do ekranu startowego
                    } label: {
                       Text("Wyloguj")
                    }
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(user: UserProfile_Previews.users[0])
    }
}
