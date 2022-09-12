//
//  EditProjectVIew.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 15/8/2022.
//

import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var project: Project

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var remiderTime: Date
    @State private var remiderMe: Bool

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationError = false

    @State private var engine = try? CHHapticEngine()

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectRemiderTime = project.remiderTime {
            _remiderTime = State(wrappedValue: projectRemiderTime)
            _remiderMe = State(wrappedValue: true)
        } else {
            _remiderTime = State(wrappedValue: Date())
            _remiderMe = State(wrappedValue: false)
        }
    }

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        Form {
            Section {
                TextField("Project name", text: $title)
                TextField("Description of this project", text: $detail)
            } header: {
                Text("Basic Settings")
            }

            Section {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            } header: {
                Text("Custom project color")
            }

            Section {
                Toggle("Show reminders", isOn: $remiderMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationError) {
                        Alert(
                            title: Text("Oops"),
                            message: Text("There is a problem, please check you have notification enabled"),
                            primaryButton: .default(Text("Check settings"), action: showAppSettings),
                            secondaryButton: .cancel()
                        )
                    }

                if remiderMe {
                    DatePicker(
                        "Reminder time",
                        selection: $remiderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            } header: {
                Text("Project remiders")
            }

            Section {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    closedToggle()
                }

                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            } footer: {
                // swiftlint:disable:next line_length
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")
            }

        }
        .navigationTitle("Edit View")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                // swiftlint:disable:next line_length
                message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
                primaryButton: .destructive(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remiderMe {
            project.remiderTime = remiderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.remiderTime = nil
                    remiderMe = false
                    showingNotificationError = true
                }
            }
        } else {
            project.remiderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func closedToggle() {
        project.closed.toggle()

        if project.closed {
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // haptic error
            }
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color ?
            [.isButton, .isSelected] : [.isButton]
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct EditProjectVIew_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
