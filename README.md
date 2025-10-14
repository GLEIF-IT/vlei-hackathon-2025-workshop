# vLEI Hackathon 2025 Workshop

This workshop has three separate modules guiding the learner through each the vLEI issue hold verify flow for vLEI credentials, Chainlink's CCID integration with the vLEI, and usage of the Cardano Veridian wallet stack.

The modules include:

1. Module 1 - vLEI OOR Permissioned Action
  - vLEI Issue-Hold-Verify Fundamentals
  - Verifying a vLEI Official Organizational Role (OOR) ACDC
2. Module 2 - vLEI-based smart contract access - CCID by Chainlink
  - Turning a vLEI into a CCID
  - vLEI-based CCID smart contract access
3. Module 3 - Confidentiality with ESSR - Veridian by Cardano
  - ESSR confidentiality agent to agent with KERI challenge response

## Architecture

This workshop uses a simplified, single signature identifier setup with one identifier for the GEDA, QVI, LE, and Person to show an end-to-end vLEI credential issuance and presentation workflow using both KERIpy and SignifyTS. The GEDA, or GLEIF External Delegated Identifier, is a KERI identifier made with the KERIpy KLI tool. The QVI, LE, and Person AID are created with Signify TS and KERIA. All of this is built on a three witness, one KERIA, and one Sally verifier deployment. The QVI identifier is a delegated identifier that is a delegate of the GEDA delegator.

See the `./images/vLEI-Workshop-architecture.png` diagram for a visual representation of the identifiers in green, the delegation between the GEDA and QVI, the credentials in yellow, and the KERIA, Witness, and Verifier (sally) infrastructure at the bottom of the diagram.

## Workshop Instructions

Follow the module specific instructions as

### Module 1 - vLEI OOR Permissioned Action

Abbreviations and names:
- KERI: Key Event Receipt Infrastructure
- ACDC: Authentic Chained Data Containers
- CESR: Composable Event Streaming
- KERIA: KERI Agent server for Signify
- SignifyTS: Typescript implementation of the Signify edge client protocol
- vLEI: verifiable Legal Entity Identifier
- OOBI: Out of Band Identifier URL
- QVI: Qualified vLEI Issuer
- LE: Legal Entity
- OOR: Official Organizational Role
- ECR: Engagement Context Role
- OOR Auth: Official Organizational Role Authorization
- ECR Auth: Engagement Context Role authorization
- AID: Autonomic Identifier
- IPEX: Issuance and Presentation EXchange Protocol

#### vLEI Module Scripts

This section explains the purpose and contents of each script. You may skip to the [instructions](#instructions) section to get started if you are ready.

- ./deploy.sh sets up the following components:
  - KERIA server
  - Three witnesses
  - vLEI Server (ACDC schema host)
- ./sig-wallet contains the Typescript code for:
  - Setting up each of the Signify Controllers and their KERIA agents.
  - Resolving Schema OOBIs of vLEI schemas (QVI, LE, OOR Auth, ECR Auth, OOR, ECR)
  - Creating KERI AIDs for the QVI, LE, and OOR holders.
- ./stop.sh shuts down the components started up by ./deploy.sh  
- ./create-geda-aid.sh
  - uses the appropriate script in `./sig-wallet/src` to create the GEDA AID using the KERIpy KLI rather than KERIA and SignifyTS.
- ./create-qvi-aid.sh
  - uses the appropriate script in `./sig-wallet/src` to create the QVI AID as a delegated AID from the GEDA AID.
- ./create-le-aid.sh
  - uses the appropriate script in `./sig-wallet/src` to create the LE AID.
- ./create-person-aid.sh
  - uses the appropriate script in `./sig-wallet/src` to create the person AID that will receive the OOR and ECR credentials.
- ./create-qvi-acdc-credential.sh  
  - uses the appropriate script in `./sig-wallet/src` to issue the QVI credential from the GEDA AID to the QVI AID.
- ./create-le-acdc-credential.sh
  - uses the appropriate script in `./sig-wallet/src` to issue the LE credential from the QVI AID to the LE AID, chaining the LE to the QVI credential.
- ./create-oor-acdc-credential.sh
  - uses the appropriate script in `./sig-wallet/src` to issue the OOR Auth credential from the LE AID to the QVI AID, chaining the OOR Auth credential to the LE credential, and then issuing the OOR credential from the QVI AID to the Person AID, chaining the OOR credential to the OOR Auth credential.


#### vLEI Module Instructions



### Module 2 - TBD

### Module 3 - TBD