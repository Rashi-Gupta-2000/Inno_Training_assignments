import './Card.css'

const Card = (props) => {

    const clickHandler = () => {
        if (!props.disableCard) {
            props.handleChoice(props.card)
        }
    }

    return(
    <div className = "card">
        <div className={props.flipped ? "flipped" : ""}>
          <img className = "front" src={props.card.src} alt="card front"/>
          <img className = "back" src="/images/cover.jpg" onClick={clickHandler} alt = "card back" />
        </div>
    </div>
    )
}

export default Card