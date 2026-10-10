---
title: "Root Cause - 03 - The Stability Charter"
---

The evening air carried the familiar, pungent scent of roasted chili and fermented black beans from their home province. 

Don had picked an unassuming private dining room in a small, authentic restaurant tucked away in an alley behind the tech park. On the round wooden table, two steaming bowls of braised beef with pickled radish sat beside a pot of dark, earthy hometown brick tea.

Don poured tea into Phil’s ceramic cup using both hands, letting out a booming laugh that bounced off the wooden paneling. The corporate polish and executive shorthand he used in board reviews were gone, replaced by the rolling cadence of their shared local dialect.

“Drink up, Phil!” Don laughed, shaking his head. “When I joined six months ago and saw what you built here over the last three years—nurturing this entire platform from a single prototype to millions of orders a day—I was blown away. There aren't many engineers who have that kind of grit.”

Phil picked up his cup, feeling the heat through the ceramic. “We barely slept five hours a night in those early startup days.”

“And you carried this whole company on your back,” Don chuckled, leaning back as he poured another cup of tea. “We’re entering a new phase now, Phil. The board is pushing hard for our Series C roadshow, and the investors want to see modern, distributed microservice architecture. That’s why I brought Frank in—he has the Big Tech pedigree to build the future lines.”

Don looked at Phil. “Frank is building the new architecture, but I need someone I truly trust to make sure the foundation doesn’t collapse under our feet. I want you to work alongside Harry on platform stability.”

Phil took a slow sip of tea, watching the steam rise. He didn't answer immediately.

Don leaned in closer across the table.

“Harry isn't like the typical startup managers you’ve seen,” Don said in a low dialect cadence. “He spent over a decade at IBM before moving into internet unicorns. His enterprise methodology, process discipline, and structural management skills are on another level. Working alongside him right now will teach you organizational leverage you can’t learn anywhere else.”

Phil listened quietly. At that time, "stability" was just a vague term to him—for three years, his work had simply been about shipping features, fixing bottlenecks, and rushing to put out fires whenever alarms rang. He didn't have complicated theories about enterprise architecture, but he could hear the genuine goodwill in Don’s voice. If working alongside Harry gave him a chance to learn how a seasoned leader managed organizations and kept large systems running, it was worth exploring.

Phil placed his cup on the table with a soft click. 

“Thanks for the advice, Don,” Phil said. “I’ll give it a try.”

Don broke into a broad grin, clapping his hands together with a chuckle. “Drink up! Let's enjoy the dinner.”

* * *

Early the next morning at eight-thirty.

Phil sat at his desk. The office was nearly empty, illuminated only by the pale gray morning light. He opened his laptop, navigated to his drafts folder, and selected the resignation letter that had sat on his machine for days.

He hit delete and emptied the trash bin.

He decided to stay—curious to see what he could learn from Harry and whether they could stop the platform from constantly breaking down.

Phil walked over to Harry’s desk at the end of the aisle.

Harry looked up from a classic matte-black IBM ThinkPad, his thumb resting near the red TrackPoint. “Phil.”

“I’ve thought it through,” Phil said. “I accept the Special Technical Assistant role.”

Harry lowered the lid of his laptop until the latch caught with a quiet click.

“Good,” Harry said, leaning back. “I don't believe in vague mandates. We start with two concrete assignments:
First, establish daily visibility over our **Critical Core APIs**—latency, error rates, and throughput curves. I want that report delivered every morning at nine o’clock.
Second, conduct a deep forensic audit of our **Historical Outages** over the past twelve months. Cut through the surface excuses and find the real, recurring systemic vulnerabilities.”

Phil nodded. “On it.”

* * *

For the next two days, Phil immersed himself in telemetry dashboards, post-mortem incident archives, and operations logs. 

While reviewing incident logs over in the infrastructure area, Tiger tossed a stack of post-mortems onto the desk.

“I am sick of babysitting this Erlang black box,” Tiger grumbled, his coffee mug hitting the table with a sharp thud. “Not a single engineer in this entire company knows how to read Erlang. When RabbitMQ hits a memory lockup at three in the morning, all we can do is blindly restart the nodes and pray. We have zero experience maintaining it, and the team is completely furious being on call for it!”

Sky leaned against the cubicle partition, arms crossed.

“Tiger's right,” Sky said, looking at Phil. “We should replace RabbitMQ entirely with **Kafka**. It’s built natively on the JVM, matching our core application stack. If we hit an obscure bug or an undocumented edge case with no answers online, we don’t have to pray—we can just open the source code, debug the broker internals ourselves on the JVM, and patch it. That has to be our next architectural stage.”

“I agree,” Phil said, looking over the telemetry charts. “Since RabbitMQ is going to be eliminated completely, we shouldn't waste any engineering effort trying to patch or tune its internals. We just don't touch it. Our real objective for the next stage is replacing it directly with Kafka, but coordinating that migration across dozens of product lines will take organization-wide alignment.”

Cross-referencing the historical outage timeline against the newly established Critical API metrics confirmed the broader picture.

Phil met Harry in a glass meeting room with a single sheet of diagnostic charts.

“Here is our reality, Harry,” Phil placed the paper on the glass table. “First, over eighty percent of our outages happen during or right after new feature releases. Because we lack staged release safeguards and immediate rollback mechanisms, minor deployment bugs regularly escalate into full platform disasters. 

Second, RabbitMQ is sitting on a live grenade. It has crashed four times this year because of zero tenant isolation: whenever a single consumer service hangs or mismanages message processing, unacknowledged queues rapidly pile up in RAM, tripping Erlang memory alarms that rate-limit every producer and freeze order dispatch. The operations team is furious babysitting an Erlang black box. Since we plan to eliminate RabbitMQ entirely, we won't waste time touching or patching it—our next milestone is replacing it directly with Kafka.

Third, our Elasticsearch clusters are experiencing severe performance bottlenecks, suffering from extreme query latency spikes and intermittent freezes during peak traffic hours.”

Harry looked over the failure distribution chart. “Can’t you work directly with each service team to drive these fixes?”

“Bilateral persuasion doesn't work,” Phil answered. “If I approach individual team leads one by one, stability always loses to feature delivery deadlines. To enforce release gates and migrate message brokers across all teams, we need organizational leverage.”

Harry leaned back, folding his hands over the glass table. “Then we don't rely on informal chats. We build an institutional governance mechanism—a designated stability owner embedded in every engineering team.”

“A company-wide Stability Group,” Phil agreed.

Harry picked up the drafted proposal. “Let me take this to Don.”

Ten minutes later, Harry sat across from Don in a small breakout room.

Don leaned back. As Harry laid the failure charts across the table and outlined the Stability Group proposal, Don looked over the data and nodded.

“If the dev teams just assign random junior engineers, this group won't have the leverage to stop bad code in their pods,” Don said, leaning forward. “Let’s upgrade the standard: in small teams, the Team Lead must participate directly. In large teams, the Team Lead must appoint their primary backup—the senior engineer being groomed as their designated successor.”

Don picked up his fountain pen and signed the charter with a smooth, decisive stroke.

“Approved,” Don said. “Let’s bring them all into the room.”

* * *

The following afternoon, the main glass-walled conference room was filled to capacity.

Phil stood at the head of the long wooden table, his laptop plugged into the central projector. Harry sat quietly along the side wall, his laptop resting open on his lap. Andrew sat near the front, adjusting his wire-rimmed glasses and placing a bottle of still soda water on the table alongside his incident logs. Sky leaned back in his chair with crossed arms, surveying the room. Around the table sat every development team lead and their designated high-potential backups from across the engineering department.

A low murmur of skepticism filled the air. Several team leads checked their watches or tapped on their phones, assuming this was just another ceremonial corporate sync that would eat into their sprint hours.

The frosted-glass door swung open.

Don walked in, giving a casual wave.

He walked straight to the front of the long table, standing beside Phil. He looked around at the assembled leads and architects.

“We are officially appointing Phil as the head of the Stability Group starting today,” Don announced in a relaxed, conversational tone that carried the unmistakable weight of executive sponsorship.

Don turned to Phil, clapping him firmly on the shoulder in full view of every lead in the room.

“Phil, if there is anything difficult to push through, you can tell Harry or come find me directly.”

Don gave a nod to the room, chuckled softly, and strolled back out the door.

The frosted glass door clicked shut behind him.

The casual simplicity of Don's announcement only amplified its authority. The cynical murmurs had vanished completely; the team leads exchanged subtle glances and quietly slipped their phones into their pockets. There was no ambiguity left: this wasn't an optional committee—Phil had been given the CTO's direct, personal backing.

Harry sat quietly along the side wall, taking in the room. In the corner, Sky leaned back in his chair with crossed arms.

Every pair of eyes in the room turned toward the head of the table.

Phil stood at the podium. He took a steady breath, placed his hands on the wooden table, and pressed the clicker in his hand.

The projector beam cut through the dim room, throwing a massive, full-link architectural topography across the central wall: a sprawling landscape of microservices, turbulent message queues, fragile cache clusters, and unmapped dependencies that carried millions of orders every single day.

Phil looked at the glowing architecture, then turned his gaze back to the silent room.

“Gentlemen,” Phil said softly. “Let’s chart the horizon.”

* * *

### SRE Field Notes (Chapter 3 Architecture Takeaways)

#### 1. The "Change Trigger" Rule in SRE
Industry telemetry consistently confirms that **over 70%–80% of all severe production outages are triggered directly by a change** (code deployments, configuration updates, or database schema migrations):
* **Why it happens**: Systems in steady state rarely collapse on their own. New releases introduce altered query plans, un-warmed JIT code, memory leaks, and connection pool spikes into live traffic.
* **Best Practice**: Never treat deployment as a simple file-copy operation. A mature SRE practice requires **Automated Release Gating** (canary observation windows, real-time error rate baselines, and rapid single-click rollback mechanisms) so that problematic versions can be reverted immediately within minutes before minor deployment defects escalate into platform-wide outages.

#### 2. The "One Bad Consumer" Trap: Why RabbitMQ Blocks All Producers
In multi-tenant RabbitMQ clusters without isolation, a single broken downstream consumer can bring down the entire company's publishing pipeline:
* **The Memory Cascade**: If a single consumer pod crashes, deadlocks, or processes messages too slowly, unacknowledged messages rapidly accumulate in RAM on that RabbitMQ broker node.
* **The Global Publisher Alarm (`vm_memory_high_watermark`)**: When node memory crosses the 40% threshold, RabbitMQ protects itself by triggering cluster-wide **Publisher Flow Control**. The broker abruptly stops reading TCP packets from **all producers**—not just the queue that is overflowing. 
* **The Cascading Outage**: Unrelated critical producers (such as order dispatch and payment services) get blocked on socket writes, rapidly exhausting their Tomcat/Netty worker threads and triggering platform-wide 504 Gateway Timeouts.
* **Strategic Rule on Sunset Systems ("Don't Touch the Dying Broker")**: When a fragile legacy system is slated for total elimination, avoid wasting engineering bandwidth on complex internal patches or localized fine-tuning. Freeze the legacy broker in place, avoid risky intrusive modifications, and direct all organizational momentum toward a clean architectural replacement with a modern, high-throughput distributed platform (like Apache Kafka).

