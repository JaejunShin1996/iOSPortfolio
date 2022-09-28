//
//  EditProjectVIew.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 15/8/2022.
//

import CloudKit
import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    enum CloudStatus {
        case checking, absent, exists
    }

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var project: Project

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var reminderTime: Date
    @State private var reminderMe: Bool

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationError = false

    @AppStorage("username") var username: String?
    @State private var showingSignIn = false

    @State private var cloudStatus = CloudStatus.checking
    @State private var cloudError: CloudError?

    @State private var engine = try? CHHapticEngine()

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _reminderMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _reminderMe = State(wrappedValue: false)
        }
    }

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        Form {
            Section {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
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
                Toggle("Show reminders", isOn: $reminderMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationError) {
                        Alert(
                            title: Text("Oops"),
                            message: Text("There is a problem, please check you have notification enabled"),
                            primaryButton: .default(Text("Check settings"), action: showAppSettings),
                            secondaryButton: .cancel()
                        )
                    }

                if reminderMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
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
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(
                        title: Text("Delete project?"),
                        // swiftlint:disable:next line_length
                        message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
                        primaryButton: .destructive(Text("Delete"), action: delete),
                        secondaryButton: .cancel()
                    )
                }
            } footer: {
                // swiftlint:disable:next line_length
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")
            }

        }
        .onAppear(perform: updateCloudStatus)
        .onDisappear(perform: dataController.save)
        .navigationTitle("Edit View")
        .toolbar {
            switch cloudStatus {
            case .checking:
                ProgressView()
            case .exists:
                Button {
                    removeFromCloud(deleteLocal: false)
                } label: {
                    Label("Remove from iCloud", systemImage: "icloud.slash")
                }
            case .absent:
                Button(action: uploadToCloud) {
                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                }
            }
        }
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localizedMessage)
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if reminderMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    reminderMe = false
                    showingNotificationError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        if cloudStatus == .exists {
            removeFromCloud(deleteLocal: true)
        } else {
            dataController.delete(project)
            presentationMode.wrappedValue.dismiss()
        }
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

    func updateCloudStatus() {
        project.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }

    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys

            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(let success):
                    print("success: \(success)")
                case .failure(let error):
                    cloudError = error.getCloudKitError()
                }
                updateCloudStatus()
            }

            cloudStatus = .checking

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }

    func removeFromCloud(deleteLocal: Bool) {
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success(let success):
                print("success: \(success)")
                if deleteLocal {
                    dataController.delete(project)
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                cloudError = error.getCloudKitError()
            }
            updateCloudStatus()
        }

        cloudStatus = .checking

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct EditProjectVIew_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
