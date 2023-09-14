import Foundation
import Network

class DummySender {
    private var connection: NWConnection?
    private var srtla: Srtla
    
    init(srtla: Srtla) {
        self.srtla = srtla
    }
    
    func sendPacket() {
        if connection == nil {
            guard let port = self.srtla.localPort() else {
                return
            }
            connection = NWConnection(host: "localhost", port: NWEndpoint.Port(integerLiteral: port), using: .udp)
            connection!.stateUpdateHandler = handleDummySrtStateChange(to:)
            connection!.start(queue: DispatchQueue.main)
        }
        let data = Data("An SRT packet".utf8)
        connection!.send(content: data, completion: .contentProcessed { error in
            if let error {
                logger.error("srtla: Local dummy send error: \(error)")
            }
        })
    }
    
    private func handleDummySrtStateChange(to state: NWConnection.State) {
        logger.debug("srtla: Dummy SRT state change to \(state)")
    }
}
