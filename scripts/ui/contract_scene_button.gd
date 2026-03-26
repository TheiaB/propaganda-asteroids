extends Node2D
@onready var button: Button = %AcceptContract
@onready var scroll_container: ScrollContainer = $VBoxContainer/ScrollContainer
#@onready var contract_text: RichTextLabel = $VBoxContainer/ScrollContainer/ContractText
@onready var contract_text : Label = $VBoxContainer/ScrollContainer/Contract
@onready var time: Timer = $Timer

var last_scroll_value := -1
signal accept_contract

func _ready():
	show_contract()
	time.start()
	time.timeout.connect(_on_timeout)
	
func _on_timeout() -> void:
	if $Ad1.visible == false and $Ad3.visible == false:
		$Ad1.visible = true
		$Ad2.visible = false
	elif $Ad1.visible == false and $Ad2.visible == false:
		$Ad3.visible = false
		$Ad2.visible = true
	elif $Ad2.visible == false and $Ad3.visible == false:
		$Ad3.visible = true
		$Ad1.visible = false

func show_contract() -> void:
	contract_text.text = """
Hiring notice:

Dear Employee,

We are delighted to have you on board the MarsK Inc.™ fleet!

We are sure you will adjust quickly to your wonderful new job opportunity and become an invaluable asset to this company!

We strive to create a culture where you feel seen, safe, connected, and to make sure you feel comfortable aligning with our core values. We seek qualified candidates from a broad pool and are focused on building and maintaining resources and networks so you can reach your maximum potential.

A new state of the art Cargo ship equipped with all necessary safety and support systems will be ready in the Construction Bay for you to get comfortable in!

And don't forget, MarsK Inc.™ means family!

Sincerely, 
MarsK Inc.™ HR department. 


Legal terms:

§1 duty of confidentiality
all Documents received by this company and any internal knowledge about this company are strictly confidential.The employee agrees to refrain from disclosing related information to any third party including personal associates, industry competitors, news organizations and legal institutions. This agreement is to be upheld during the term of this contract as well as after the termination of this contract due to any reason.
Any breach of this agreement will result in the immediate termination of this contract and further consequences.

§2 Safety features
The Cargo ship provides all necessary maneuverability and safety features including a MainMetall™ Laser gun to protect the ship from possible space debris. 
The Company will not in any circumstances provide any additional systems.
The employee is free to personally acquire and install any systems to their ship.
Ownership of all systems installed in the ship will be transferred to the company's holdings. 

§3 Permanent supervision
The employee agrees to the implementation of systems in the ship, personal apartment as well as their body which includes audio and video technology as well as vital signs tracker to supervise work efforts and ensure maximum efficiency for everyone.

The recorded material is property of the company and can be saved, edited and distributed at its sole discretion. Monetary value gained through the distribution of the recorded material is going at a rate of 100% to the profits of the company.

§4 Liability in case of harm
This company can not be held not liable for any mental or physical harm to the employee including but not limited to: suffocation, instant disintegration, isolation, starvation, dehydration, electrification.

§5 Liability for Damage to the Spaceship:
The employee is civilly liable for any damage, malfunction, or impairment to the spaceship caused by negligence, non-compliance with procedures, or willful misconduct, and agrees to fully reimburse all related costs.

If for any circumstance the employee is not able to reimburse the company to the total amount owed, the full responsibility for the remaining debt will be transferred to the closest family member or associated person of the employee.

§6 decreasing work efficiency
Any type of effort to decrease work efficiency including “unionizing” or “striking” or affiliation with any so called “workers rights” organizations is strictly prohibited and will result in immediate termination.

§7 Training and Information
The company provides general documentation on safety protocols and operational procedures as well as training in the form of AI enhanced AR and VR introductions provided by our trusted partners Beta Inc.™ to the provided ship. However, correct understanding and application of this information are the sole responsibility of the employee, who must independently adapt to dynamic and constantly evolving operational conditions.

§8 Support and Assistance
Technical and medical support is provided exclusively via remote systems with no guaranteed response times. In emergency situations, the employee is required to autonomously manage critical issues until external intervention, which may not be timely or effective.

§9 Exclusion of Protection
No additional guarantees or protections beyond those expressly indicated in internal protocols are provided. Failure to apply or inefficiency of such protections shall not result in any liability for the company.

§10 Acceptance of Terms
By accepting this contract, the employee has unconditionally accepted all terms listed herein, including those limiting company liability and transferring all risks to the employee.
"""
	scroll_container.get_v_scroll_bar().value = 0
	var scroll_bar = scroll_container.get_v_scroll_bar()
	if not scroll_bar.is_connected("value_changed", _on_scroll_check):
		scroll_bar.value_changed.connect(_on_scroll_check)
	_on_scroll_check(scroll_container.get_v_scroll_bar().value)

func _on_scroll_check(value: float) -> void:
	var scrollbar = scroll_container.get_v_scroll_bar()
	var at_bottom = value >= scrollbar.max_value - scrollbar.page - 1
	if at_bottom:
		button.disabled = false
	else:
		button.disabled = true


func _on_accept_contract_pressed() -> void:
	SoundManager5000.basic_button_sfx.play_one_shot()
	SoundManager5000.music_contract.stop()
	SoundManager5000.music_gamestart.stop()
	emit_signal("accept_contract")
