using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBullet : MonoBehaviour {

    public PlayerBulletExplosion explosionPrefab;
    public float lifeTime = 5f;
    public float speed = 0.1f;

	private IEnumerator Start () {
        yield return new WaitForSeconds(lifeTime);
        PlayerBulletExplosion p = GameObject.Instantiate(explosionPrefab, transform.parent).GetComponent<PlayerBulletExplosion>();
        p.gameObject.transform.position = transform.position;

        Destroy(gameObject);
	}

    private void Update() {
        transform.position = Vector3.Lerp(transform.position, transform.position + transform.forward, speed);
    }

}
